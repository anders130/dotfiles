{
    lib,
    pkgs,
    ...
}: {
    imports = [
        ./extensions.nix
        ./keybinds.nix
    ];

    config = {
        services.xserver = {
            enable = true;
            displayManager.gdm.enable = lib.mkDefault true;
            desktopManager.gnome.enable = true;
        };

        environment.gnome.excludePackages = with pkgs; [
            gnome-photos
            gnome-tour
            atomix # puzzle game
            cheese # webcam tool
            epiphany # web browser
            evince # document viewer
            geary # email reader
            gnome-characters
            gnome-music
            gnome-terminal
            hitori # sudoku game
            iagno # go game
            nautilus
            totem # video player
            tali # poker game
        ];

        hm.dconf.settings = {
            "org/gnome/desktop/interface" = {
                clock-show-seconds = true;
                clock-show-weekday = true;
                enable-hot-corners = false;
                show-battery-percentage = true;
            };
            "org/gnome/shell".app-picker-layout = "[]"; # sort apps by name
            "org/gnome/mutter" = {
                edge-tiling = true;
                dynamic-workspaces = true;
                workspaces-only-on-primary = true;
            };
            "org/gnome/shell/app-switcher".current-workspace-only = false;
            # Fix gnome touchpad right click. See [this](https://git.gnome.org/browse/gsettings-desktop-schemas/commit/?id=77ff1d91d974b2aaebbf7d748f1cd904bc75330b)
            "org/gnome/desktop/peripherals/touchpad".click-method = "default";
        };
    };
}
