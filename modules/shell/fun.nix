{
    den.aspects.fun.homeManager = {pkgs, ...}: {
        home = {
            packages = with pkgs; [
                asciiquarium-transparent # ascii art aquarium
                cbonsai
                cowsay
                fortune
                lolcat
                pipes
                sl
                sssnake
                unimatrix # ascii art matrix
            ];
            shellAliases = {
                aquarium = "asciiquarium -s -t";
                matrix = "unimatrix -as 98";
                snake = "sssnake -s 15";
            };
        };
    };
}
