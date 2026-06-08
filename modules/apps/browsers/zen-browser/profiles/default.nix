{
    dots.apps.provides.zen-browser.homeManager = {
        config,
        lib,
        pkgs,
        ...
    }: let
        inherit (lib) mkOption types mapAttrs optionalAttrs;
        baseExtensions = with pkgs.firefox-addons; [
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
    in {
        options.my.zen.profiles = mkOption {
            description = "Zen profiles to create, keyed by profile name.";
            default = {};
            type = types.attrsOf (types.submodule {
                options = {
                    id = mkOption {
                        type = types.nullOr types.int;
                        default = null;
                        description = "Profile id (omit for the default profile).";
                    };
                    extraExtensions = mkOption {
                        type = types.listOf types.package;
                        default = [];
                        description = "Profile-specific addons on top of the shared base.";
                    };
                };
            });
        };
        config.my.zen.profiles.default = {};
        config.programs.zen-browser.profiles = mapAttrs (
            name: p:
                {
                    isDefault = name == "default";
                    extensions.packages = baseExtensions ++ p.extraExtensions;
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
                }
                // optionalAttrs (p.id != null) {inherit (p) id;}
        )
        config.my.zen.profiles;
    };
}
