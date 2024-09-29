{
    config,
    lib,
    pkgs,
    ...
}: {
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
            cheese # webcam tool
            gnome-music
            gnome-terminal
            gedit # text editor
            epiphany # web browser
            geary # email reader
            evince # document viewer
            gnome-characters
            totem # video player
            tali # poker game
            iagno # go game
            hitori # sudoku game
            atomix # puzzle game
        ]);
    };
}
