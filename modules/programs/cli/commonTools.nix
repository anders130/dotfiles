{
    lib,
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        broot # better tree
        cachix # nix cache manager
        curl
        ffmpeg # video downloader
        fzf # fuzzy finder
        librespeed-cli # speedtest-cli
        unzip
        wget
        yazi # terminal file manager
        zip

        # fun stuff
        cbonsai
        cowsay
        fortune
        lolcat
        pipes
        sl
    ];

    # directory dev-environments
    programs.direnv.enable = lib.mkDefault true;
}
