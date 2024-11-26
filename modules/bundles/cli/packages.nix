{
    config,
    lib,
    pkgs,
    ...
}: {
    config = lib.mkIf config.modules.bundles.cli.enable {
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
    };
}
