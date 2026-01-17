let
    port = 5520;
    workDir = "/var/lib/hytale";
in {
    virtualisation.oci-containers.containers.hytale = {
        image = "indifferentbroccoli/hytale-server-docker";
        environment = {
            DEFAULT_PORT = toString port;
            ENABLE_BACKUPS = "TRUE";
            SERVER_NAME = "NixOS Hytale Server";
            MAX_MEMORY = "8G";
        };
        volumes = [
            "/var/lib/hytale/data:/home/hytale/server-files"
        ];
        extraOptions = [
            "--tty"
            "--stop-timeout=30"
        ];
        autoStart = false;
        user = "root:root";
        ports = ["${toString port}:5520/udp"];
    };
    systemd.tmpfiles.settings."50-hytale"."${workDir}/data".d = {
        user = "1000";
        group = "1000";
        mode = "0755";
    };

    networking.firewall.allowedUDPPorts = [port];
}
