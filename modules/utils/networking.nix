{
    hostName,
    lib,
    ...
}: let
    inherit (lib) mkDefault mkIf mkOption types;
in {
    options = {
        address = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "IP address of the host";
            example = "192.168.178.10";
        };
        interface = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Network interface to use";
            example = "eth0";
        };
    };
    config = cfg: {
        networking = {
            inherit hostName;
            firewall.enable = mkDefault true;
            networkmanager.enable = mkDefault true;
            interfaces = mkIf (cfg.interface != null && cfg.address != null) {
                ${cfg.interface}.ipv4.addresses = [
                    {
                        inherit (cfg) address;
                        prefixLength = 24;
                    }
                ];
            };
        };
    };
}
