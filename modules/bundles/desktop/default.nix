{
    config,
    lib,
    ...
}: let
    cfg = config.bundles.desktop;
in {
    imports = [
        ./defaultApps.nix
        ./gaming.nix
        ./packages.nix
    ];

    options.bundles.desktop = {
        enable = lib.mkEnableOption "Enable desktop bundle";
        gaming.enable = lib.mkEnableOption "Enable gaming stuff";
        mainMonitor = lib.mkOption {
            type = lib.types.str;
            default = "DP-1";
            description = "The main monitor";
        };
    };

    config = lib.mkIf cfg.enable {
        modules = {
            ags.enable = lib.mkDefault true;
            applications = {
                alacritty.enable = lib.mkDefault true;
                anki.enable = lib.mkDefault true;
                discord.enable = lib.mkDefault true;
                firefox.enable = lib.mkDefault true;
                kitty.enable = lib.mkDefault true;
                nautilus = {
                    enable = lib.mkDefault true;
                    terminal = lib.mkDefault "kitty";
                };
                rofi.enable = lib.mkDefault true;
                youtube-music.enable = lib.mkDefault true;
            };
            hardware = {
                kanata.enable = lib.mkDefault true;
                printing.enable = lib.mkDefault true;
                sound.enable = lib.mkDefault true;
            };
            hypr = {
                enable = lib.mkDefault true;
                mainMonitor = lib.mkDefault cfg.mainMonitor;
                autostartApps = [
                    { cmd = "signal-desktop --start-in-tray"; }
                    { cmd = "sleep 2 && zapzap --hideStart"; }
                    { cmd = "sleep 3 && vesktop --start-minimized"; }
                ];
                displayManager = {
                    enable = lib.mkDefault true;
                    autoLogin.enable = lib.mkDefault true;
                };
            };
            swaync.enable = lib.mkDefault true;
            theming = {
                plymouth.enable = lib.mkDefault true;
                stylix = {
                    enable = lib.mkDefault true;
                    desktop.enable = lib.mkDefault true;
                };
            };
        };

        services.xserver.enable = true;
    };
}
