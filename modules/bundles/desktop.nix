{
    inputs,
    lib,
    ...
}: let
    inherit (lib) mkDefault;
in {
    imports = with inputs.self.modules.nixos; [
        discord
        zen-browser
        desktop
        nautilus
        bitwarden
    ];
    hm.imports = with inputs.self.modules.homeManager; [
        kitty
        youtube-music
        signal
        qutebrowser
        element
    ];
    my.desktop.autostart = [
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
    modules = {
        programs = {
            plymouth.enable = mkDefault true;
        };
        hardware = {
            printing.enable = mkDefault true;
            audio.enable = mkDefault true;
        };
    };
}
