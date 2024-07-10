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
        btop # task manager

        # fun stuff
        cbonsai
        pipes
        lolcat
        cowsay
        sl
        fortune
    ];

    stable-packages = with pkgs; [
        python3
        dotnet-sdk_8
    ];
in {
    config = lib.mkIf config.bundles.cli.enable {
        environment.systemPackages =
            stable-packages
            ++ unstable-packages;
    };
}
