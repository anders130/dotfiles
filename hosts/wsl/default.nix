{
    pkgs,
    username,
    ...
}: {
    modules.bundles.dev.enable = true;

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

    networking.nameservers = ["8.8.4.4" "8.8.8.8"]; # business internet fix

    environment.shellAliases = {
        explorer = "/mnt/c/Windows/explorer.exe";
        docker = "/run/current-system/sw/bin/docker";
    };

    environment.systemPackages = with pkgs; [
        local.win32yank
    ];

    system.stateVersion = "23.11";
    hm.home.stateVersion = "23.11";
}
