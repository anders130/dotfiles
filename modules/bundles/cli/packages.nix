{
    config,
    lib,
    pkgs,
    ...
}: let
    unstable-packages = with pkgs.unstable; [
        curl
        wget
        zip
        unzip
        ffmpeg # video downloader
        librespeed-cli # speedtest-cli

        # fun stuff
        cbonsai
        pipes
        lolcat
        cowsay
        sl
        fortune
    ];

    stable-packages = with pkgs; [
        cachix
    ];
in {
    config = lib.mkIf config.bundles.cli.enable {
        environment.systemPackages =
            stable-packages
            ++ unstable-packages;
    };
}
