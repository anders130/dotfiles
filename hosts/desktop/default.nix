{
    pkgs,
    username,
    ...
}: {
    modules = {
        bundles = {
            dev.enable = true;
            desktop.enable = true;
            gaming.enable = true;
        };
        desktop = {
            enable = true;
            autostart = [
                "sleep 2 && zapzap --hideStart"
            ];
            monitors = {
                DP-3 = {
                    resolution = "2560x1440";
                    refreshRate = 180;
                    position = "-2560x0";
                };
                DP-1 = {
                    isMain = true;
                    resolution = "3440x1440";
                    refreshRate = 144;
                    position = "0x0";
                };
                DP-2 = {
                    resolution = "2560x1440";
                    refreshRate = 180;
                    position = "3440x0";
                };
            };
            hyprland.enable = true;
        };

        programs = {
            cli.nix.nix-daemon.enableLimit = true;
            gui = {
                zen-browser.enable = true;
                qutebrowser.enable = true;
                zapzap.enable = true;
                nextcloud-client = {
                    enable = true;
                    instance-url = "https://cloud.gollub.dev";
                    user = "jesse";
                    folder-sync = let
                        mkFolder = f: {
                            localPath = "/home/${username}/Nextcloud/${f}";
                            ignoreHiddenFiles = false;
                        };
                    in {
                        "/Documents" = mkFolder "Documents";
                        "/Photos" = mkFolder "Photos";
                        "/Music" = mkFolder "Music";
                        "/Videos" = mkFolder "Videos";
                    };
                };
                anki.enable = true;
            };
        };
        hardware = {
            amdgpu.enable = true;
            bluetooth.enable = true;
        };
    };

    services.lsfg-vk = {
        enable = true;
        ui.enable = true;
    };

    boot = {
        binfmt.emulatedSystems = ["aarch64-linux"];
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_6_12;
    };

    nix.settings.download-speed = 6250; # limit download speed to 50 Mbps

    fileSystems = let
        bindMount = drive: name: {
            name = "/home/${username}/${name}";
            value = {
                device = "${drive}/${name}";
                fsType = "none";
                options = [
                    "bind"
                    "x-gvfs-hide"
                ];
            };
        };
    in
        builtins.listToAttrs (map (bindMount "/mnt/data") [
            "Documents"
            "Downloads"
            "Music"
            "Pictures"
            "Videos"
        ]);

    # slows down boot time
    systemd.services.NetworkManager-wait-online.enable = false;

    environment.systemPackages = with pkgs; [
        plex-desktop
    ];

    services.tailscale.enable = true;

    system.stateVersion = "24.05";
    hm.home.stateVersion = "24.05";
}
