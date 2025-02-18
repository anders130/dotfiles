{
    lib,
    pkgs,
    ...
}: {
    environment = {
        systemPackages = with pkgs; [
            broot # better tree
            cachix # nix cache manager
            curl
            ffmpeg # video downloader
            fzf # fuzzy finder
            librespeed-cli # speedtest-cli
            nmap # network scanner
            unzip
            wget
            zip

            # fun stuff
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

    # directory dev-environments
    programs.direnv.enable = lib.mkDefault true;
}
