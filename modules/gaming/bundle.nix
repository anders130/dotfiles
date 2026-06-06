{dots, ...}: {
    dots.gaming = {
        includes = with dots.gaming.provides; [
            steam
            minecraft
            hytale
            lethal-company
        ];
        homeManager = {pkgs, ...}: {
            home.packages = with pkgs; [
                lutris

                # other games
                space-cadet-pinball
                supertuxkart
            ];
        };
    };
}
