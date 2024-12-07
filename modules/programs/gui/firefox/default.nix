{pkgs, ...}: let
    profileBaseConfig = {
        settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.toolbars.bookmarks.visibility" = "always";
            "devtools.toolbox.host" = "right";
        };
        userChrome = builtins.readFile ./chrome/userChrome.css;
    };
in {
    hm = {
        programs.firefox = {
            enable = true;
            package = pkgs.firefox;
            profiles = {
                private = profileBaseConfig // {
                    id = 0;
                    isDefault = true;
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
            categories = ["Application" "Network" "WebBrowser"];
            mimeType = ["text/html" "text/xml"];
        };
    };
}
