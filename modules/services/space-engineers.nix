let
    port = 27016;
    dataDir = "/var/lib/space-engineers";
in {
    virtualisation.oci-containers.containers.space-engineers = {
        image = "docker.io/devidian/spaceengineers:winestaging";
        ports = ["${toString port}:27016/udp"];
        environment = {
            WINEDEBUG = "-all";
            INSTANCE_NAME = "TestInstance";
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
    networking.firewall.allowedUDPPorts = [port];
    systemd.tmpfiles.rules = [
        "d '${dataDir}' 0755 root root - -"
        "d '${dataDir}/plugins' 0755 root root - -"
        "d '${dataDir}/instances' 0755 root root - -"
        "d '${dataDir}/SpaceEngineersDedicated' 0755 root root - -"
        "d '${dataDir}/steamcmd' 0755 root root - -"
    ];
}
