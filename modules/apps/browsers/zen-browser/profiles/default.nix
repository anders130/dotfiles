{
    den.aspects.zen-browser.homeManager = {
        config,
        lib,
        pkgs,
        ...
    }: {
        options.my.zen.profiles = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = ["default" "work"];
            description = "Zen profiles the shared base applies to.";
        };
        config.programs.zen-browser.profiles = lib.genAttrs config.my.zen.profiles (_: {
            extensions.packages = with pkgs.firefox-addons; [
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
                "browser.translations.neverTranslateLanguages" = "de,en";
                "signon.showAutoCompleteFooter" = false; # turn off integrated password manager
                "widget.use-xdg-desktop-portal.file-picker" = 1;
                "browser.tabs.allow_transparent_browser" = true;

                # stylix
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            };
            keyboardShortcuts = [
                {
                    # interferes with bitwarden autofill ctrl+shift+l
                    id = "key_inspector";
                    disabled = true;
                }
            ];
            keyboardShortcutsVersion = lib.mkDefault 19;
        });
    };
}
