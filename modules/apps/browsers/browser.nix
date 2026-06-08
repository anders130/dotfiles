{dots, ...}: {
    dots.apps.provides.browser.homeManager = {lib, ...}: let
        inherit (lib) mkOption types;
    in {
        options.my.browser = {
            searchEngines = mkOption {
                description = "Search engines keyed by shortcut; url uses %s for the query.";
                default = {};
                type = types.attrsOf (types.submodule {
                    options = {
                        url = mkOption {type = types.str;};
                        name = mkOption {
                            type = types.str;
                            default = "";
                        };
                    };
                });
            };
            defaultSearchEngine = mkOption {
                type = types.str;
                default = "";
                description = "Shortcut of the engine used for bare queries.";
            };
        };
    };
    den.aspects.browser = {
        includes = [dots.apps.provides.browser];
        homeManager.my.browser = {
            defaultSearchEngine = "d";
            searchEngines = {
                w = {
                    url = "https://www.wikipedia.org/w/index.php?title=Special:Search&search=%s";
                    name = "Wikipedia";
                };
                g = {
                    url = "https://www.google.com/search?q=%s";
                    name = "Google";
                };
                y = {
                    url = "https://youtube.com/results?search_query=%s";
                    name = "YouTube";
                };
                gm = {
                    url = "https://www.google.com/maps?q=%s";
                    name = "Google maps";
                };
                d = {
                    url = "https://duckduckgo.com/?q=%s";
                    name = "DuckDuckGo";
                };
                az.url = "https://www.amazon.com/s/?field-keywords=%s";
                sxng = {
                    url = "https://search.inetol.net/search?q=%s";
                    name = "SearXNG";
                };
                n = {
                    url = "https://search.nixos.org/packages?channel=unstable&query=%s";
                    name = "Nixpkgs";
                };
                mn = {
                    url = "https://mynixos.com/search?q=%s";
                    name = "MyNixOS";
                };
                gh = {
                    url = "https://github.com/search?type=code&q=%s";
                    name = "GitHub";
                };
                nh = {
                    url = "https://www.nixhub.io/search?q=%s";
                    name = "Nixhub.io";
                };
                nw = {
                    url = "https://wiki.nixos.org/w/index.php?search=%s";
                    name = "wiki.nixos.org";
                };
                ng = {
                    url = "https://noogle.dev/q?term=%s";
                    name = "noogle";
                };
            };
        };
    };
}
