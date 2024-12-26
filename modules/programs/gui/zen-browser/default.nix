{
    inputs,
    lib,
    pkgs,
    ...
}: {
    hm = {
        imports = [inputs.zenix.hmModules.default];
        programs.zenix = {
            package = (lib.getPkgs "zen-browser").specific;
            enable = true;
            chrome.hideTitlebarButtons = true;
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
                    userChrome = builtins.readFile ./userChrome.css;
                    userContent = builtins.readFile ./userContent.css;
                };
                work = default // {
                    isDefault = false;
                    id = 1;
                };
            };
        };
    };
}
