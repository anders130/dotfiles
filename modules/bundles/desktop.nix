{lib, ...}: {
    modules = {
        desktop = {
            enable = lib.mkDefault true;
            autostart = [
                "sleep 1 && noisetorch -i"
                "signal-desktop --start-in-tray"
                "sleep 2 && zapzap --hideStart"
                "sleep 3 && vesktop --start-minimized"
                "ssh-add-all-keys"
            ];
        };
        programs = {
            gui = {
                alacritty.enable = lib.mkDefault true;
                discord.enable = lib.mkDefault true;
                firefox.enable = lib.mkDefault true;
                kitty.enable = lib.mkDefault true;
                nautilus = {
                    enable = lib.mkDefault true;
                    terminal = lib.mkDefault "kitty";
                };
                youtube-music.enable = lib.mkDefault true;
                commonTools.enable = lib.mkDefault true;
            };
            plymouth.enable = lib.mkDefault true;
        };
        hardware = {
            kanata.enable = lib.mkDefault true;
            printing.enable = lib.mkDefault true;
            sound.enable = lib.mkDefault true;
        };
        utils.stylix = {
            enable = lib.mkDefault true;
            desktop.enable = lib.mkDefault true;
        };
    };

    services.xserver.enable = true;
}
