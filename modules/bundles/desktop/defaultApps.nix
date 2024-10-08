{
    config,
    lib,
    ...
}: {
    config = lib.mkIf config.bundles.desktop.enable {
        xdg.mime.defaultApplications = {
            "application/pdf" = "firefox.desktop";
            "image/*" = "loupe.desktop";
            "video/*" = "totem.desktop";
            "audio/*" = "gnome-music.desktop";
            "text/*" = "neovim.desktop";
        };
    };
}
