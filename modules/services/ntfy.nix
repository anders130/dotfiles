{
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (builtins) attrNames;
    inherit (lib) mapAttrsToList mkMerge mkOption types;

    domain = "ntfy.${config.networking.domain}";
    port = 2586;

    ntfyUrl = config.services.ntfy-sh.settings.base-url;
    message = pkgs.writeShellScriptBin "message" ''
        curl -fsS -u "$NTFY_TOPIC:$NTFY_PASS" -d "$1" ${ntfyUrl}/$NTFY_TOPIC
    '';
    scriptDeps = with pkgs; [
        curl
        coreutils
        message
    ];
    mkSystemdService = cfg: name: source: {
        "notify-${name}" = {
            description = "Notifications for ${name}";
            inherit (source) wantedBy after partOf;
            serviceConfig = {
                User = source.user;
                Group = source.group;
                ExecStart = lib.getExe (source.script scriptDeps);
                Restart = "on-failure";
                EnvironmentFile = cfg.targets.${source.target}.secretFile;
                Environment = "NTFY_TOPIC=${cfg.targets.${source.target}.topic}";
            };
        };
    };
in {
    options = {
        targets = mkOption {
            type = types.attrsOf (types.submodule ({name, ...}: {
                options = {
                    topic = mkOption {
                        type = types.str;
                        default = name;
                    };
                    secretFile = mkOption {
                        type = types.path;
                        description = "Secret .env file for the app that contains the `NTFY_PASS` environment variable";
                    };
                    authHash = mkOption {
                        type = types.str;
                        description = "Hashed password for the app. Optain with `ntfy user hash`";
                    };
                };
            }));
            default = {};
        };
        sources = mkOption {
            type = types.attrsOf (types.submodule ({name, ...}: {
                options = {
                    target = mkOption {
                        type = types.str;
                        description = "Name of the target to send notifications to";
                        default = name;
                    };
                    wantedBy = mkOption {
                        type = types.listOf types.str;
                    };
                    after = mkOption {
                        type = types.listOf types.str;
                    };
                    partOf = mkOption {
                        type = types.listOf types.str;
                    };
                    user = mkOption {
                        type = types.str;
                    };
                    group = mkOption {
                        type = types.str;
                    };
                    script = mkOption {
                        type = types.functionTo types.package;
                        description = "Function that takes the default dependencies as argument and returns a package";
                    };
                };
            }));
        };
    };
    config = cfg: {
        services.ntfy-sh = {
            enable = true;
            settings = {
                auth-default-access = "deny-all";
                base-url = "https://${domain}";
                listen-http = ":${toString port}";
                behind-proxy = true;
                auth-users =
                    ["jesse:$2b$10$x9ZjMlkRBvh8u5ga5.dQ.OCs06iQhOqQEsGsHt4wv5VfuMbWDYMxK:admin"]
                    ++ (mapAttrsToList (name: value: "${name}:${value.authHash}:user") cfg.targets);
                auth-access = map (name: "${name}:${name}:wo") (attrNames cfg.targets);
                enable-login = true;
            };
        };
        systemd.services = mkMerge (mapAttrsToList (mkSystemdService cfg) cfg.sources);
        modules.services.caddy.virtualHosts.${domain} = {
            inherit port;
            extraConfig = ''
                @httpget {
                    protocol http
                    method GET
                    path_regexp ^/([-_a-z0-9]{0,64}$|docs/|static/)
                }
                redir @httpget https://{host}{uri}
            '';
        };
    };
}
