{
    config,
    lib,
    pkgs,
    ...
}: {
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
    options.modules.programs.cli.commonTools = {
        enable = lib.mkEnableOption "common tools";
    };

    config = lib.mkIf config.modules.programs.cli.commonTools.enable {
        environment.systemPackages =
            unstable-packages
            ++ stable-packages;

        # directory dev-environments
        programs.direnv.enable = lib.mkDefault true;
    };
}
