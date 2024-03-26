{
    username,
    pkgs,
    ... 
}: {
    environment.variables.NIX_FLAKE_DEFAULT_HOST = "wsl";

    imports = [
        ./docker.nix
        ./vpn.nix
    ];

    wsl = {
        enable = true;
        wslConf = {
            automount.root = "/mnt";
            interop.appendWindowsPath = false;
            network.generateHosts = false;
            network.generateResolvConf = false; # business internet fix
        };
        defaultUser = username;
        startMenuLaunchers = true;
    };

    networking.nameservers = [ "8.8.4.4" "8.8.8.8" ]; # business internet fix
    # networking.nameservers = [ "195.37.105.57" ];   # bbs

    environment.shellAliases = {
        explorer = "/mnt/c/Windows/explorer.exe";
    	docker = "/run/current-system/sw/bin/docker";
    };

    environment.systemPackages = [
        (import ./win32yank.nix {inherit pkgs;})
    ];

    # fileSystems."/mnt/y" = {
    #     device = "Y:"; 
    #     fsType = "drvfs";
    # };
}
