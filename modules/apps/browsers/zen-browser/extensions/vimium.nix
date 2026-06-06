{
    den.aspects.zen-browser.homeManager = {
        config,
        lib,
        pkgs,
        ...
    }: let
        inherit (builtins) readFile;
        inherit (lib) concatStringsSep mapAttrsToList replaceStrings;
        cfg = config.my.browser;
    in {
        my.programs.zen-browser.extensions.vimium = {
            inherit (pkgs.firefox-addons.vimium.passthru) addonId;
            default.settingsVersion = "2.1.2";
            settings = {
                # default search: vimium appends the query, so drop the %s
                searchUrl = replaceStrings ["%s"] [""] cfg.searchEngines.${cfg.defaultSearchEngine}.url;
                searchEngines =
                    cfg.searchEngines
                    |> mapAttrsToList (key: e: "${key}: ${e.url} ${e.name}")
                    |> concatStringsSep "\n";
                keyMappings = ''
                    unmap J
                    unmap K
                    map J nextTab
                    map K previousTab
                '';
                newTabUrl = "https://online.bonjourr.fr";
                userDefinedLinkHintCss = readFile (pkgs.fetchFromGitHub {
                    owner = "catppuccin";
                    repo = "vimium";
                    rev = "3e81c66636668fabd740927c437ad87b14593528";
                    sha256 = "sha256-WDBH90+asu5aiQcMVIm3SOoWQLCB30h2LY+umWH62hs=";
                }
                + "/themes/catppuccin-vimium-macchiato.css");
                exclusionRules = [
                    {
                        passKeys = "f";
                        pattern = "https?://www.youtube.com/*";
                    }
                    {
                        passKeys = "";
                        pattern = "https?://www.overleaf.com/*";
                    }
                    {
                        passKeys = "f";
                        pattern = "https?://app.plex.tv/*";
                    }
                    {
                        passKeys = "";
                        pattern = "https?://zty.pe/*";
                    }
                    {
                        passKeys = "";
                        pattern = "https?://windows11.qemu.ds1/*";
                    }
                ];
            };
        };
    };
}
