{
    config,
    pkgs,
    ...
}: let
    port = 7777;
in {
    systemd.tmpfiles.rules = ["d /var/lib/astroneer 0755 admin users - -"];

    networking.firewall.allowedUDPPorts = [port];

    virtualisation.oci-containers.containers.astroneer = {
        image = "docker.io/whalybird/astroneer-server:latest";
        autoStart = false;
        ports = ["${toString port}:7777/udp"];
        volumes = ["/var/lib/astroneer:/astrotux/AstroneerServer/Astro/Saved"];
        # PUBLIC_IP is resolved at startup from the domain since Astroneer doesn't support DNS
        environmentFiles = ["/run/astroneer-public-ip.env"];
        extraOptions = ["--tty" "--interactive"];
    };

    systemd.services."podman-astroneer".serviceConfig.ExecStartPre = pkgs.writeShellScript "astroneer-resolve-ip" ''
        ip=$(${pkgs.dnsutils}/bin/dig +short ${config.networking.domain} | tail -n1)
        echo "PUBLIC_IP=$ip" > /run/astroneer-public-ip.env
        ini=/var/lib/astroneer/Config/WindowsServer/AstroServerSettings.ini
        if [ -f "$ini" ]; then
            ${pkgs.gnused}/bin/sed -i "s/PublicIP=.*/PublicIP=$ip/" "$ini"
        fi
    '';
}
