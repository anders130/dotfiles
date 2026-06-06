{
    dots.desktop.provides.window-rules.homeManager = {lib, ...}: let
        inherit (lib) mkEnableOption mkOption types;
    in {
        options.my.desktop.windowRules = mkOption {
            default = {};
            description = "Per-application window behaviour, consumed by the window manager.";
            type = types.attrsOf (types.submodule {
                options = {
                    match = mkOption {
                        type = types.str;
                        description = "Window class/title to match.";
                    };
                    matchType = mkOption {
                        type = types.enum ["class" "title" "initial_title"];
                        default = "class";
                    };
                    opacity = mkOption {
                        type = types.enum ["default" "opaque" "blur"];
                        default = "default";
                        description = ''
                            default = the global transparency; opaque = no transparency;
                            blur = keep blur but no transparency (for apps that set their own).
                        '';
                    };
                    float = mkEnableOption "floating the window";
                    center = mkEnableOption "centering the window";
                    noScreenShare = mkEnableOption "hiding the window from screen shares";
                    size = mkOption {
                        type = types.nullOr types.str;
                        default = null;
                        description = ''Window size, e.g. "1280 720".'';
                    };
                };
            });
        };
    };
}
