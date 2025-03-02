{
    inputs,
    pkgs,
    ...
}: {
    hm = {
        imports = [inputs.zenix.hmModules.default];
        programs.zenix = {
            enable = true;
            chrome = {
                hideTitlebarButtons = true;
                tabGroups = true;
            };
            profiles = rec {
                default = {
                    isDefault = true;
                    id = 0;
                    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
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
                };
                work = default // {
                    isDefault = false;
                    id = 1;
                };
            };
        };
    };
}
