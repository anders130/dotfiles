{username, ...}: {
    services.jellyfin = {
        enable = true;
        openFirewall = true;
        user = username;
    };
}
