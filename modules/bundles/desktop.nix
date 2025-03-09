{lib, ...}: let
    inherit (lib) mkDefault;
in {
    modules = {
        desktop = {
            enable = mkDefault true;
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
                discord.enable = mkDefault true;
                firefox.enable = mkDefault true;
                kitty.enable = mkDefault true;
                nautilus = {
                    enable = mkDefault true;
                    terminal = mkDefault "kitty";
                };
                youtube-music.enable = mkDefault true;
                commonTools.enable = mkDefault true;
            };
            plymouth.enable = mkDefault true;
        };
        hardware = {
            kanata.enable = mkDefault true;
            printing.enable = mkDefault true;
            sound.enable = mkDefault true;
        };
        utils = {
            stylix = {
                enable = mkDefault true;
                desktop.enable = mkDefault true;
            };
            qt.enable = mkDefault true;
        };
    };

    services.xserver.enable = true;
}
