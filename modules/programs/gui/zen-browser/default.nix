{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: {
    nixpkgs.overlays = [inputs.firefox-addons.outputs.overlays.default];
    hm = {
        imports = [inputs.zen-browser.homeModules.beta];
        stylix.targets.zen-browser = {
            enableCss = false;
            profileNames = ["default" "work"];
        };
        programs.zen-browser = {
            enable = true;
            nativeMessagingHosts = [pkgs.vdhcoapp];
            setAsDefaultBrowser = true;
            languagePacks = ["en-US" "de-DE"];
            policies = {
                AutofillAddressEnabled = true;
                AutofillCreditCardEnabled = false;
                DisableAppUpdate = true;
                DisableFeedbackCommands = true;
                DisableFirefoxStudies = true;
                DisablePocket = true;
                DisableTelemetry = true;
                DontCheckDefaultBrowser = true;
                NoDefaultBookmarks = true;
                OfferToSaveLogins = false;
                EnableTrackingProtection = {
                    Value = true;
                    Locked = true;
                    Cryptomining = true;
                    Fingerprinting = true;
                };
            };
            profiles = rec {
                default = {
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
                    keyboardShortcutsVersion = lib.mkDefault 17;
                    userChrome = import ./_userChrome.nix config.lib.stylix.colors;
                    userContent = import ./_userContent.nix config.lib.stylix.colors;
                };
                work = lib.mkMerge [
                    default
                    {
                        id = 1;
                        isDefault = false;
                        extensions.packages =
                            default.extensions.packages
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
