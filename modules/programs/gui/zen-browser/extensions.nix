{
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (builtins) attrNames concatStringsSep readFile toJSON;
    inherit (pkgs.nur.repos.rycee) firefox-addons;
    vimium = {
        inherit (firefox-addons.vimium.passthru) addonId;
        default = toJSON {settingsVersion = "2.1.2";};
        settings = rec {
            searchUrl = "https://search.inetol.net/search?q=";
            searchEngines = ''
                w: https://www.wikipedia.org/w/index.php?title=Special:Search&search=%s Wikipedia
                g: https://www.google.com/search?q=%s Google
                y: https://youtube.com/results?search_query=%s YouTube
                gm: https://www.google.com/maps?q=%s Google maps
                d: https://duckduckgo.com/?q=%s DuckDuckGo
                az: https://www.amazon.com/s/?field-keywords=%s
                sxng: ${searchUrl}%s SearXNG
                # nix stuff
                n: https://search.nixos.org/packages?query=%s Nixpkgs
                mn: https://mynixos.com/search?q=%s MyNixOS
                gh: https://github.com/search?type=code&q=%s GitHub
                nh: https://www.nixhub.io/search?q=%s Nixhub.io
                nw: https://wiki.nixos.org/w/index.php?search=%s wiki.nixos.org
                ng: https://noogle.dev/q?term=%s noogle
            '';
            keyMappings = ''
                unmap J
                unmap K
                map J nextTab
                map K previousTab
            '';
            newTabUrl = "https://online.bonjourr.fr";
            userDefinedLinkHintCss = readFile ./vimium.css;
            exclusionRules = toJSON [
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
            ];
        };
    };
    darkreader = {
        inherit (firefox-addons.darkreader.passthru) addonId;
        default = toJSON {};
        settings.theme = with config.lib.stylix.colors; {
            darkSchemeBackgroundColor = "#${base00}";
            darkSchemeTextColor = "#${base05}";
            selectionColor = "#${base04}";
        };
    };
    set-extension-settings = pkgs.writeShellScriptBin "set-extension-settings" ''
        profile_name="$1"

        if [[ -z $profile_name ]]; then
            echo "No profile name provided, exiting..."
            exit 1
        fi

        profile_dir="$HOME/.zen/$profile_name"
        db_file="$profile_dir/storage-sync-v2.sqlite"

        if [[ ! -f $db_file ]]; then
            echo "No database found, skipping..."
            exit 0
        fi

        # Set Vimium settings
        ${pkgs.sqlite}/bin/sqlite3 "$db_file" <<EOF
        INSERT INTO storage_sync_data (ext_id, data)
        SELECT '${vimium.addonId}', json('${vimium.default}')
        WHERE NOT EXISTS (SELECT 1 FROM storage_sync_data WHERE ext_id = '${vimium.addonId}');

        UPDATE storage_sync_data
        SET data = json_set(data, '$.searchEngines', '${vimium.settings.searchEngines}')
        WHERE ext_id = '${vimium.addonId}';

        UPDATE storage_sync_data
        SET data = json_set(data, '$.keyMappings', '${vimium.settings.keyMappings}')
        WHERE ext_id = '${vimium.addonId}';

        UPDATE storage_sync_data
        SET data = json_set(data, '$.searchUrl', '${vimium.settings.searchUrl}')
        WHERE ext_id = '${vimium.addonId}';

        UPDATE storage_sync_data
        SET data = json_set(data, '$.newTabUrl', '${vimium.settings.newTabUrl}')
        WHERE ext_id = '${vimium.addonId}';

        UPDATE storage_sync_data
        SET data = json_set(data, '$.userDefinedLinkHintCss', '${vimium.settings.userDefinedLinkHintCss}')
        WHERE ext_id = '${vimium.addonId}';

        UPDATE storage_sync_data
        SET data = json_set(data, '$.exclusionRules', json('${vimium.settings.exclusionRules}'))
        WHERE ext_id = '${vimium.addonId}';

        INSERT INTO storage_sync_data (ext_id, data)
        SELECT '${darkreader.addonId}', json('${darkreader.default}')
        WHERE NOT EXISTS (SELECT 1 FROM storage_sync_data WHERE ext_id = '${darkreader.addonId}');

        UPDATE storage_sync_data
        SET data = json_set(data, '$.theme.darkSchemeBackgroundColor', '${darkreader.settings.theme.darkSchemeBackgroundColor}')
        WHERE ext_id = '${darkreader.addonId}';

        UPDATE storage_sync_data
        SET data = json_set(data, '$.theme.darkSchemeTextColor', '${darkreader.settings.theme.darkSchemeTextColor}')
        WHERE ext_id = '${darkreader.addonId}';

        UPDATE storage_sync_data
        SET data = json_set(data, '$.theme.selectionColor', '${darkreader.settings.theme.selectionColor}')
        WHERE ext_id = '${darkreader.addonId}';

        EOF
    '';
in {
    hm.home = {
        packages = [set-extension-settings];
        activation.setExtensionSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
            ${concatStringsSep "\n" (map (profileName: ''${set-extension-settings}/bin/set-extension-settings ${profileName}'') (attrNames config.hm.programs.zenix.profiles))}
        '';
    };
}
