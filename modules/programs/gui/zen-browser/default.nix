{
    inputs,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkMerge mkSymlink;
in {
    hm = {
        imports = [inputs.zenix.homeModules.default];
        programs.zenix = {
            enable = true;
            chrome = {
                hideTitlebarButtons = true;
            };
            profiles = let
                base = {
                    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
                        bitwarden
                        darkreader
                        github-file-icons
                        istilldontcareaboutcookies
                        return-youtube-dislikes
                        stylus
                        ublock-origin
                        video-downloadhelper
                        vimium
                        wappalyzer
                    ];
                    settings = {
                        "widget.use-xdg-desktop-portal.file-picker" = 1;
                        "browser.translations.neverTranslateLanguages" = "de,en";
                    };
                    userChrome = mkSymlink ./userChrome.css;
                };
            in {
                default = mkMerge [
                    base
                    {
                        isDefault = true;
                        id = 0;
                    }
                ];
                work = mkMerge [
                    base
                    {
                        isDefault = false;
                        id = 1;
                        extensions.packages =
                            base.extensions.packages
                            ++ [
                                pkgs.inputs.clock-mate.default
                            ];
                    }
                ];
            };
        };
        wayland.windowManager.hyprland.settings.windowrule = [
            "no_screen_share true, match:title ^(Extension: \\(Bitwarden Password Manager\\) - Bitwarden — Zen Browser)$"
        ];
    };
}
