{
    config,
    lib,
    username,
    ...
}: {
    options.modules.plex = {
        enable = lib.mkEnableOption "plex";
    };

    config = lib.mkIf config.modules.plex.enable {
        services.plex = {
            enable = true;
            dataDir = "/var/lib/plex";
            openFirewall = true;
            user = username;
            group = "users";
        };
    };
}