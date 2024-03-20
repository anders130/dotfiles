{
    secrets,
    username,
    config,
    pkgs,
    nix-index-database,
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
        rustup
        lua
        python3
        dotnet-sdk_8
        gcc
        gnumake
        nodejs_21
    ];
in {
    imports = [
        ./neovim.nix
        nix-index-database.hmModules.nix-index
    ];

    home = {
        stateVersion = "22.11";
        username = "${username}";
        homeDirectory = "/home/${username}";

        packages =
            stable-packages
            ++ unstable-packages
            ++ [];
    };

    programs = {
        home-manager.enable = true;

        lsd = {
            enable = true;
            enableAliases = true;
        };

        git = {
            enable = true;
            package = pkgs.unstable.git;
            delta.enable = true;
            delta.options = {
                line-numbers = true;
                side-by-side = true;
                navigate = true;
            };
            userEmail = "${secrets.git_credentials.email}";
            userName = "${secrets.git_credentials.username}";
            extraConfig = {
                push = {
                    default = "current";
                    autoSetupRemote = true;
                };
                merge = {
                    conflictstyle = "diff3";
                };
                diff = {
                    colorMoved = "default";
                };
                credential = {
                    credentialStore = "secretservice";
                    helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
                };
            };
        };
    };
}
