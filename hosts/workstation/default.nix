{
    lib,
    pkgs,
    username,
    ...
}: {
    modules = {
        bundles = {
            dev.enable = true;
            desktop.enable = true;
        };
        desktop = {
            enable = true;
            monitors.eDP-1 = {
                isMain = true;
                resolution = "1920x1200";
                refreshRate = 60;
            };
            hyprland = {
                enable = true;
                extraConfig = ''
                    source = ./override.conf
                '';
            };
        };
        programs.gui = {
            nwg-displays.enable = true;
            zen-browser.enable = true;
            qutebrowser.enable = true;
            nextcloud-client = {
                enable = true;
                instance-url = "https://cloud.gollub.dev";
                user = "jesse";
                folder-sync = {
                    "/" = {
                        localPath = "/home/${username}/Nextcloud";
                        ignoreHiddenFiles = false;
                    };
                    "/Photos/Wallpapers" = {
                        localPath = "/home/${username}/Pictures/Wallpapers";
                        ignoreHiddenFiles = false;
                    };
                };
            };
        };
        hardware = {
            amdgpu.enable = true;
            bluetooth.enable = true;
            displaylink.enable = true;
        };
    };

    hm.xdg = {
        configFile."hypr/override.conf" = lib.mkSymlink ./hyprland.conf;
        desktopEntries.zenForWork = {
            name = "Zen for Work";
            genericName = "Web Browser";
            exec = "zen -p work";
            icon = "zen";
            terminal = false;
            categories = ["Application" "Network" "WebBrowser"];
            mimeType = ["text/html" "text/xml"];
        };
    };

    services = {
        tailscale.enable = true;
        fprintd.enable = true;
    };

    boot = {
        bootspec.enable = true;
        initrd.systemd.enable = true;
        loader.systemd-boot.enable = lib.mkForce false;
        lanzaboote = {
            enable = true;
            pkiBundle = "/etc/secureboot";

            settings = {
                console-mode = "auto";
                editor = false;
            };
        };
        kernelPackages = pkgs.linuxPackages_latest;
    };

    environment.systemPackages = with pkgs; [
        logisim-evolution
    ];

    system.stateVersion = "24.05";
    hm.home.stateVersion = "24.05";
}
