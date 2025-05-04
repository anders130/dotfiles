{pkgs, ...}: let
    package = pkgs.local.plexamp;
in {
    users.users.plexamp = {
        isSystemUser = true;
        group = "plexamp";
        home = "/var/lib/plexamp";
    };
    users.groups.plexamp = {};
    systemd.services.plexamp = {
        description = "Plexamp headless server";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        serviceConfig = {
            User = "plexamp";
            WorkingDirectory = "/var/lib/plexamp";
            ExecStart = "${package}/bin/plexamp";
            Restart = "on-failure";
        };
    };
    networking.firewall.allowedTCPPorts = [
        32500
        20000
    ];
}
