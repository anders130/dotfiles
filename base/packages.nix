{
    pkgs,
    ...
}: let
    unstable-packages = with pkgs.unstable; [
        curl
        neovim
        wget
        zip
        unzip
        ripgrep
        fzf
        ffmpeg # video downloader
        librespeed-cli # speedtest-cli
        btop # task manager
        nixd

        # fun stuff
        cbonsai
        pipes
        lolcat
        cowsay
        sl
        fortune
    ];

    stable-packages = with pkgs; [
        # compilers etc
        rustup
        lua
        python3
        dotnet-sdk_8
        gcc
        gnumake
        nodejs_22
        go
    ];
in {
    environment.systemPackages =
        stable-packages
        ++ unstable-packages;
}
