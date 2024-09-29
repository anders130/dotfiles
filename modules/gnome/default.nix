{
    config,
    lib,
    pkgs,
    username,
    ...
}: {
    imports = [
        ./keybinds.nix
    ];

    options.modules.gnome = {
        enable = lib.mkEnableOption "gnome";
    };

    config = lib.mkIf config.modules.gnome.enable {
        services.xserver = {
            enable = true;
            displayManager.gdm.enable = lib.mkDefault true;
            desktopManager.gnome.enable = true;
        };

        environment.gnome.excludePackages = (with pkgs; [
            gnome-photos
            gnome-tour
        ]) ++ (with pkgs.gnome; [
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
        ]);

        home-manager.users.${username}.dconf.settings = {
            "org/gnome/desktop/interface" = {
                clock-show-seconds = true;
                clock-show-weekday = true;
                show-battery-percentage = true;
            };
            "org/gnome/shell".app-picker-layout = "[]"; # sort apps by name
            "org/gnome/mutter" = {
                edge-tiling = true;
                dynamic-workspaces = true;
                workspaces-only-on-primary = false;
            };
        };
    };
}
