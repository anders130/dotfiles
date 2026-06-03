{
    flake.modules.nixos.kdeconnect = {pkgs, ...}: {
        programs.kdeconnect = {
            enable = true;
            package = pkgs.kdePackages.kdeconnect-kde;
        };
    };
}
