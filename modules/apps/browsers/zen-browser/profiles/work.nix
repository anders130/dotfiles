{den, ...}: {
    flake-file.inputs.clock-mate.url = "github:clock-mate/extension";
    den.aspects.zen-browser.provides.work = {
        # the work profile is built by base zen-browser from my.zen.profiles
        includes = [den.aspects.zen-browser];
        homeManager = {
            inputs',
            pkgs,
            ...
        }: {
            my.zen.profiles.work = {
                id = 1;
                extraExtensions = [inputs'.clock-mate.packages.default];
            };
            home.packages = [
                (pkgs.writeShellScriptBin "zen-work" ''
                    exec zen-beta -P work "$@"
                '')
            ];
            xdg.desktopEntries.zenWork = {
                name = "Zen Work";
                genericName = "Web Browser";
                exec = "zen-work %U";
                icon = "zen-browser";
                terminal = false;
                categories = ["Application" "Network" "WebBrowser"];
                mimeType = ["text/html" "text/xml"];
            };
        };
    };
}
