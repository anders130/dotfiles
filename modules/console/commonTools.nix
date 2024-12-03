{
    lib,
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        curl
        wget
        zip
        unzip
        ffmpeg # video downloader
        librespeed-cli # speedtest-cli
        cachix

        # fun stuff
        cbonsai
        pipes
        lolcat
        cowsay
        sl
        fortune
    ];

    # directory dev-environments
    programs.direnv.enable = lib.mkDefault true;
}
