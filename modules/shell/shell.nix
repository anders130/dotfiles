{den, ...}: {
    den.aspects.shell = {
        includes = with den.aspects; [
            starship
            fastfetch
            atuin
            yazi
            fun
        ];
        nixos = {pkgs, ...}: {
            environment.systemPackages = with pkgs; [
                nix-output-monitor
                yt-dlp
                zoxide
                fd
            ];
        };
        homeManager = {pkgs, ...}: {
            home.packages = with pkgs; [
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
            ];
            programs.bat.enable = true;
            home.shellAliases.cat = "bat";
        };
    };
}
