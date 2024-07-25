{
    config,
    lib,
    pkgs,
    username,
    ...
}: let
    profileBaseConfig = {
        settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.toolbars.bookmarks.visibility" = "always";
            "devtools.toolbox.host" = "right";
        };
        userChrome = builtins.readFile ./chrome/userChrome.css;
    };
in {
    options.modules.applications.firefox = {
        enable = lib.mkEnableOption "firefox";
    };

    config = lib.mkIf config.modules.applications.firefox.enable {
        home-manager.users.${username} = {
            programs.firefox = {
                enable = true;
                package = pkgs.unstable.firefox;
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
    };
}
