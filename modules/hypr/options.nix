{lib, ...}: {
    options = {
        terminal = lib.mkOption {
            type = lib.types.str;
            default = "kitty";
        };
        appLauncher = lib.mkOption {
            type = lib.types.str;
            default = "pgrep rofi && pkill rofi || rofi -show drun -show-icons -matching fuzzy -sort -sorting-method fzf";
        };
        mainMonitor = lib.mkOption {
            type = lib.types.str;
            default = "DP-1";
        };
        autostartApps = lib.mkOption {
            type = lib.types.listOf (lib.types.submodule {
                options = {
                    cmd = lib.mkOption {
                        type = lib.types.str;
                        description = "Command to execute";
                    };
                    windowName = lib.mkOption {
                        type = lib.types.str;
                        description = "Window name to close";
                        default = "";
                    };
                    minimize = lib.mkOption {
                        type = lib.types.bool;
                        description = "Minimize window with hyprctl";
                        default = false;
                    };
                };
            });
            default = [];
            description = "List of apps to autostart";
        };
        displayManager = {
            enable = lib.mkEnableOption "Enable lightdm display manager";
            autoLogin.enable = lib.mkEnableOption "Enable autologin";
        };
        browser = lib.mkOption {
            type = lib.types.str;
            default = "firefox";
            description = "Browser to use";
        };
    };
    config = {};
}
