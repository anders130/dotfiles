{
    lib,
    pkgs,
    ...
}: {
    options.modules.hypr = {
        enable = lib.mkEnableOption "Enable hypr2";
        terminal = lib.mkOption {
            type = lib.types.str;
            default = "${pkgs.kitty}/bin/kitty";
        };
        appLauncher = lib.mkOption {
            type = lib.types.str;
            default = "pgrep rofi && pkill rofi || rofi -show drun -show-icons -matching fuzzy -sort -sorting-method fzf";
        };
        mainMonitor = lib.mkOption {
            type = lib.types.str;
            default = "DP-1";
        };
    };
}
