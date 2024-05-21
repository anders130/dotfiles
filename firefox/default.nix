{
    username,
    pkgs,
    ...
}: let 
    profileBaseConfig = {
        settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.toolbars.bookmarks.visibility" = "always";
        };
        userChrome = builtins.readFile(./chrome/userChrome.css);
    };
in {
    home-manager.users.${username} = { config, ... }: {
        programs.firefox = {
            enable = true;
            package = pkgs.unstable.firefox;
            profiles = {
                private = profileBaseConfig // {
                    id = 0;
                    isDefault = true;
                    settings = {
                        "browser.uiCustomization.state" = builtins.readFile(./settings/browser.uiCustomization.state.json);
                    };
                };
                work = profileBaseConfig // {
                    id = 1;
                };
            };
        };

        xdg.desktopEntries.firefoxWork = {
            name = "Firefox Work";
            genericName = "Web Browser";
            exec = "firefox -P work";
            icon = "firefox";
            terminal = false;
            categories = [ "Application" "Network" "WebBrowser" ];
            mimeType = [ "text/html" "text/xml" ];
        };
    };
}
