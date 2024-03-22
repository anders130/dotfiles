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

        # fun stuff
        cbonsai
        asciiquarium
        cmatrix
        pipes
        lolcat
        cowsay
        sl
        fortune
    ];

    stable-packages = with pkgs; [
        git-credential-manager

        # compilers etc
        rustup
        lua
        python3
        dotnet-sdk_8
        gcc
        gnumake
        nodejs_21
    ];
in {
    environment.systemPackages = 
        stable-packages
        ++ unstable-packages;
}
