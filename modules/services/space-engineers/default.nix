{lib, ...}: let
    inherit (lib) mkOption types;
in {
    options = {
        port = mkOption {
            type = types.int;
            default = 27016;
        };
        instanceName = mkOption {
            type = types.str;
            default = "default";
            description = "The name of the Space Engineers instance.";
        };
        dataDir = mkOption {
            type = types.str;
            default = "/var/lib/space-engineers";
            description = "The directory where Space Engineers stores its data.";
        };
    };
    config = cfg: let
        inherit (cfg) dataDir;
    in {
        virtualisation.oci-containers.containers.space-engineers = {
            image = "docker.io/devidian/spaceengineers:winestaging";
            ports = ["${toString cfg.port}:27016/udp"];
            environment = {
                WINEDEBUG = "-all";
                INSTANCE_NAME = cfg.instanceName;
                PUBLIC_IP = "0.0.0.0";
            };
            volumes = [
                "${dataDir}/plugins:/appdata/space-engineers/plugins"
                "${dataDir}/instances:/appdata/space-engineers/instances"
                "${dataDir}/SpaceEngineersDedicated:/appdata/space-engineers/SpaceEngineersDedicated"
                "${dataDir}/steamcmd:/root/.steam"
            ];
            extraOptions = ["--network=host"];
        };
        networking.firewall.allowedUDPPorts = [cfg.port];
        systemd.tmpfiles.rules = [
            "d '${dataDir}' 0755 root root - -"
            "d '${dataDir}/plugins' 0755 root root - -"
            "d '${dataDir}/instances' 0755 root root - -"
            "d '${dataDir}/SpaceEngineersDedicated' 0755 root root - -"
            "d '${dataDir}/steamcmd' 0755 root root - -"
        ];
    };
}
