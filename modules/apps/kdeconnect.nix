{
    den.aspects.kdeconnect.nixos = {pkgs, ...}: {
        programs.kdeconnect = {
            enable = true;
            package = pkgs.kdePackages.kdeconnect-kde;
        };
    };
}
