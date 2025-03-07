{
    config,
    lib,
    pkgs,
    ...
}: let
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
        gh: https://github.com/search?q=%s GitHub
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
    userDefinedLinkHintCss = builtins.readFile ./vimium.css;
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
    ];
    ext_id = pkgs.nur.repos.rycee.firefox-addons.vimium.passthru.addonId;
    set-vimium-settings = pkgs.writeShellScriptBin "set-vimium-settings" ''
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
        SELECT '${ext_id}', json('{"settingsVersion":"2.1.2"}')
        WHERE NOT EXISTS (SELECT 1 FROM storage_sync_data WHERE ext_id = '${ext_id}');

        UPDATE storage_sync_data
        SET data = json_set(data, '$.searchEngines', '${searchEngines}')
        WHERE ext_id = '${ext_id}';

        UPDATE storage_sync_data
        SET data = json_set(data, '$.keyMappings', '${keyMappings}')
        WHERE ext_id = '${ext_id}';

        UPDATE storage_sync_data
        SET data = json_set(data, '$.searchUrl', '${searchUrl}')
        WHERE ext_id = '${ext_id}';

        UPDATE storage_sync_data
        SET data = json_set(data, '$.newTabUrl', '${newTabUrl}')
        WHERE ext_id = '${ext_id}';

        UPDATE storage_sync_data
        SET data = json_set(data, '$.userDefinedLinkHintCss', '${userDefinedLinkHintCss}')
        WHERE ext_id = '${ext_id}';

        UPDATE storage_sync_data
        SET data = json_set(data, '$.exclusionRules', json('${builtins.toJSON exclusionRules}'))
        WHERE ext_id = '${ext_id}';

        EOF
    '';
in {
    hm.home = {
        packages = [set-vimium-settings];
        activation.setVimiumSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
            ${builtins.concatStringsSep "\n" (map (profileName: ''${set-vimium-settings}/bin/set-vimium-settings ${profileName}'') (builtins.attrNames config.hm.programs.zenix.profiles))}
        '';
    };
}

