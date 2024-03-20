{
    username,
    hostname,
    pkgs,
    inputs,
    ...
}: {
    imports = [
        ./fish
        ./tmux
    ];

    time.timeZone = "Europe/Berlin";
    networking.hostName = "${hostname}";

    # SSH
    services.openssh.enable = true;

    users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
            "docker"
        ];
    };
    
    home-manager.users.${username} = {
        imports = [
            ./home
        ];
    };

    system.stateVersion = "22.11";

    virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune.enable = true;
    };

    nix = {
        settings = {
            trusted-users = [username];

            accept-flake-config = true;
            auto-optimise-store = true;
        };

        registry.nixpkgs.flake = inputs.nixpkgs;

        nixPath = [
            "nixpkgs=${inputs.nixpkgs.outPath}"
            "nixos-config=/etc/nixos/configuration.nix"
            "/nis/var/nix/profiles/per-user/root/channels"
        ];

        package = pkgs.nixFlakes;
        extraOptions = ''experimental-features = nix-command flakes'';

        gc = {
            automatic = true;
            options = "--delete-older-than 7d";
        };
    };

    environment.systemPackages = with pkgs; [
        git-credential-manager
    ];

    # for secret storing stuff
    services.gnome.gnome-keyring.enable = true;
}
