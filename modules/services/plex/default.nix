{username, ...}: {
    services.plex = {
        enable = true;
        dataDir = "/var/lib/plex";
        openFirewall = true;
        user = username;
        group = "users";
    };
}
