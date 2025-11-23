{lib, ...}: let
    inherit (builtins) mapAttrs;
    inherit (lib) mkEnableOption mkForce mkOption types;
in {
    options.virtualHosts = mkOption {
        type = types.attrsOf (types.submodule {
            options = {
                from = mkOption {
                    type = types.str;
                    default = "localhost";
                    description = "IP address to proxy from";
                };
                port = mkOption {
                    type = types.nullOr types.int;
                    default = null;
                };
                extraConfig = mkOption {
                    type = types.lines;
                    default = "";
                };
                headers = mkOption {
                    type = types.lines;
                    default = "";
                };
                local = mkEnableOption "LAN only. Important for pihole's local domain list.";
            };
        });
    };
    config = cfg: {
        services.caddy = {
            enable = true;
            virtualHosts = mapAttrs (_: value: {
                extraConfig = ''
                    ${
                        if value.local
                        then "tls internal"
                        else ""
                    }
                    ${value.extraConfig}
                    ${
                        if value.port != null
                        then ''
                            reverse_proxy ${value.from}:${toString value.port} {
                                ${value.headers}
                            }
                        ''
                        else ""
                    }
                '';
            })
            cfg.virtualHosts;
        };
        networking.firewall.allowedTCPPorts = [
            80
            443
        ];
        services.nginx.enable = mkForce false;
    };
}
