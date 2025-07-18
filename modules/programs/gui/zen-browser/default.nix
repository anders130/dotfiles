{
    inputs,
    lib,
    pkgs,
    ...
}: {
    hm = {
        imports = [inputs.zenix.homeModules.default];
        programs.zenix = {
            enable = true;
            chrome = {
                hideTitlebarButtons = true;
            };
            profiles = rec {
                default = {
                    isDefault = true;
                    id = 0;
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
                    settings."widget.use-xdg-desktop-portal.file-picker" = 1;
                    userChrome = lib.mkSymlink ./userChrome.css;
                };
                work =
                    default
                    // {
                        isDefault = false;
                        id = 1;
                        extensions.packages =
                            default.extensions.packages
                            ++ [
                                pkgs.inputs.clock-mate.default
                            ];
                    };
            };
        };
        wayland.windowManager.hyprland.settings.windowrule = [
            "noscreenshare, title:^(Extension: \\(Bitwarden Password Manager\\) - Bitwarden — Zen Browser)$"
        ];
    };
}
