{dots, ...}: {
    dots.gaming = {
        includes = with dots.gaming.provides; [
            steam
            minecraft
            hytale
        ];
        homeManager = {pkgs, ...}: {
            home.packages = with pkgs; [
                lutris
                r2modman

                # other games
                space-cadet-pinball
                supertuxkart
            ];
        };
    };
}
