{
    pkgs,
    lib,
    config,
    inputs,
    ...
}: {
    imports = [inputs.nixos-wsl.nixosModules.wsl];

    options.wslIntegration = lib.mkEnableOption "wslIntegration";

    config = cfg: {
        wsl = lib.mkIf cfg.wslIntegration {
            docker-desktop.enable = false;

            extraBin = with pkgs; [
                # Binaries for Docker Desktop wsl-distro-proxy
                {src = "${coreutils}/bin/mkdir";}
                {src = "${coreutils}/bin/cat";}
                {src = "${coreutils}/bin/whoami";}
                {src = "${coreutils}/bin/ls";}
                {src = "${busybox}/bin/addgroup";}
                {src = "${su}/bin/groupadd";}
                {src = "${su}/bin/usermod";}
            ];
        };

        systemd.services.docker-desktop-proxy.script = lib.mkForce (
            if cfg.wslIntegration
            then ''
                ${config.wsl.wslConf.automount.root}/wsl/docker-desktop/docker-desktop-user-distro proxy --docker-desktop-root ${config.wsl.wslConf.automount.root}/wsl/docker-desktop "C:\Program Files\Docker\Docker\resources"''
            else ''
                echo "WSL integration is disabled"
            ''
        );
    };
}
