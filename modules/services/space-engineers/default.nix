{
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkOption mapAttrsToList types;
    inherit (builtins) concatStringsSep;
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
        settings = mkOption {
            type = types.attrs;
            default = {
                ServerName = "NixOS Space Engineers";
                PauseGameWhenEmpty = false;
            };
            description = "Space Engineers settings, inside the SpaceEngineers-Dedicated.cfg file.";
        };
    };
    config = cfg: let
        inherit (cfg) dataDir;
        cfgDir = "${dataDir}/instances/${cfg.instanceName}";
        cfgFilePath = "${cfgDir}/SpaceEngineers-Dedicated.cfg";
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
            "d '${cfgDir}' 0755 root root - -"
            "C '${cfgFilePath}' 0644 root root - ${./SpaceEngineers-Dedicated.cfg}"
        ];
        systemd.services.space-engineers-config = {
            description = "Patch Space Engineers config";
            after = ["docker-space-engineers.service"];
            requires = ["docker-space-engineers.service"];
            serviceConfig = {
                Type = "oneshot";
                ExecStart = let
                    edits =
                        cfg.settings
                        |> mapAttrsToList (k: v: ''-u "/MyConfigDedicated/${k}" -v "${toString v}"'')
                        |> concatStringsSep " ";
                in
                    pkgs.writeShellScript "patch-se-cfg" ''
                        cfgFile="${cfgDir}/SpaceEngineers-Dedicated.cfg"
                        for i in {1..30}; do
                          if [ -f "$cfgFile" ]; then
                            ${pkgs.xmlstarlet}/bin/xmlstarlet ed -L ${edits} "$cfgFile"
                            exit 0
                          fi
                          sleep 2
                        done
                        echo "Config file not found after 60s" >&2
                        exit 1
                    '';
            };
            wantedBy = ["multi-user.target"];
        };
    };
}
