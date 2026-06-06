{
    den,
    inputs,
    ...
}: {
    flake-file.inputs = {
        zen-browser.url = "github:0xc000022070/zen-browser-flake";
        firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    };

    den.aspects.zen-browser = {
        includes = [den.aspects.browser];
        nixos.nixpkgs.overlays = [inputs.firefox-addons.outputs.overlays.default];
        homeManager = {
            imports = [inputs.zen-browser.homeModules.beta];
            stylix.targets.zen-browser = {
                enableCss = false;
                profileNames = ["default" "work"];
            };
            programs.zen-browser = {
                enable = true;
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
            };
            wayland.windowManager.hyprland.settings.windowrule = [
                "no_screen_share true, match:title ^(Extension: \\(Bitwarden Password Manager\\) - Bitwarden — Zen Browser)$"
            ];
            xdg.desktopEntries.zenWork = {
                name = "Zen Work";
                genericName = "Web Browser";
                exec = "zen-beta -P work";
                icon = "zen-browser";
                terminal = false;
                categories = ["Application" "Network" "WebBrowser"];
                mimeType = ["text/html" "text/xml"];
            };
        };
    };
}
