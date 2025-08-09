{lib, ...}: let
    inherit (lib) mkDefault;
in {
    modules = {
        desktop = {
            enable = mkDefault true;
            autostart = let
                # afterLogin = cmd: "while pgrep -x hyprlock > /dev/null; do sleep 0.5; done && ${cmd}";
                afterLogin = cmd: "while [ ! -f /tmp/hyprland/first_lock_done ]; do sleep 0.1; done; rm -f /tmp/hyprland/first_lock_done; while true; do if output=$(caelestia shell lock isLocked); then if [ \"$output\" = \"false\" ]; then break; fi; fi; sleep 0.5; done && ${cmd}";
            in [
                "sleep 1 && noisetorch -i"
                "uwsm app -- signal-desktop --start-in-tray"
                "sleep 3 && uwsm app -- vesktop --start-minimized"
                "ssh-add-all-keys"

                "uwsm app -- bash -c '${afterLogin "nextcloud --background"}'"
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
