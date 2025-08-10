{lib, ...}: let
    inherit (lib) mkDefault;
in {
    modules = {
        desktop = {
            enable = mkDefault true;
            autostart = [
                "signal-desktop --start-in-tray"
                {
                    delay = 1.0;
                    command = "noisetorch -i";
                }
                {
                    delay = 3.0;
                    command = "vesktop --start-minimized";
                }
                {
                    command = "nextcloud --background";
                    afterFirstLogin = true;
                }
                {
                    command = "ssh-add-all-keys";
                    isApp = false;
                }
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
}
