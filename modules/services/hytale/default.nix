let
    port = 5520;
    workDir = "/var/lib/hytale";
in {
    virtualisation.oci-containers.containers.hytale = {
        image = "deinfreu/hytale-server:experimental";
        environment = {
            SERVER_IP = "0.0.0.0";
            SERVER_PORT = "5520";
            PROD = "FALSE";
            DEBUG = "FALSE";
            TZ = "Europe/Berlin";
        };
        volumes = [
            "/var/lib/hytale/data:/home/container"
            "/etc/machine-id:/etc/machine-id:ro"
        ];
        extraOptions = ["--tty"];
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
