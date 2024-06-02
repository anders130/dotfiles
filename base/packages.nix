{
    pkgs,
    ...
}: let
    unstable-packages = with pkgs.unstable; [
        curl
        git
        neovim
        wget
        zip
        unzip
        ripgrep
        bat # better cat
        fastfetch
        fzf
        zoxide # better cd
        broot # better tree
        starship # shell prompt
        ffmpeg # video downloader
        librespeed-cli # speedtest-cli
        nix-output-monitor # prettier nix command outputs
        btop # task manager

        # fun stuff
        cbonsai
        asciiquarium-transparent
        cmatrix
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
