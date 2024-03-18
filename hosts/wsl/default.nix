{
    username,
    pkgs,
    lib,
    config,
    ... 
}: {
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

        docker-desktop.enable = false;

    	extraBin = with pkgs; [
            # Binaries for Docker Desktop wsl-distro-proxy
            { src = "${coreutils}/bin/mkdir"; }
            { src = "${coreutils}/bin/cat"; }
            { src = "${coreutils}/bin/whoami"; }
            { src = "${coreutils}/bin/ls"; }
            { src = "${busybox}/bin/addgroup"; }
            { src = "${su}/bin/groupadd"; }
            { src = "${su}/bin/usermod"; }
        ];
    };

    networking.nameservers = [ "8.8.4.4" "8.8.8.8" ]; # business internet fix
    # networking.nameservers = [ "195.37.105.57" ];   # bbs

    systemd.services.docker-desktop-proxy.script = lib.mkForce ''${config.wsl.wslConf.automount.root}/wsl/docker-desktop/docker-desktop-user-distro proxy --docker-desktop-root ${config.wsl.wslConf.automount.root}/wsl/docker-desktop "C:\Program Files\Docker\Docker\resources"'';

    programs.fish.shellAliases = {
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
