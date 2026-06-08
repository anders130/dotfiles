{
    dots,
    inputs,
    ...
}: {
    flake-file.inputs = {
        zen-browser.url = "github:0xc000022070/zen-browser-flake";
        firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    };

    dots.apps.provides.zen-browser = {
        includes = with dots; [
            apps.provides.browser
            desktop.provides.window-rules
        ];
        nixos.nixpkgs.overlays = [inputs.firefox-addons.outputs.overlays.default];
        homeManager = {config, ...}: {
            imports = [inputs.zen-browser.homeModules.beta];
            stylix.targets.zen-browser = {
                enableCss = false;
                profileNames = builtins.attrNames config.my.zen.profiles;
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
            my.desktop.windowRules = {
                zen = {
                    match = "zen.*";
                    opacity = "blur";
                };
                bitwarden-extension = {
                    matchType = "title";
                    match = ''^(Extension: \(Bitwarden Password Manager\) - Bitwarden — Zen Browser)$'';
                    noScreenShare = true;
                };
                picture-in-picture = {
                    matchType = "initial_title";
                    match = "Picture-in-Picture";
                    float = true;
                    size = "1280 720";
                };
            };
        };
    };
}
