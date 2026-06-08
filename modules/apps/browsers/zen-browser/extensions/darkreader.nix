{
    dots.apps.provides.zen-browser.homeManager = {
        config,
        pkgs,
        ...
    }: {
        my.programs.zen-browser.extensions.darkreader = {
            inherit (pkgs.firefox-addons.darkreader.passthru) addonId;
            default = {};
            settings = {
                theme = with config.lib.stylix.colors; {
                    darkSchemeBackgroundColor = "#${base00}";
                    darkSchemeTextColor = "#${base05}";
                    selectionColor = "#${base04}";
                };
            };
        };
    };
}
