{
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (builtins) attrNames concatStringsSep isAttrs isList readFile toJSON;
    inherit (lib) flatten mapAttrsToList mkOption types;
    inherit (pkgs.nur.repos.rycee) firefox-addons;

    sqlForExtension = _: ext: let
        prepare = v:
            if isAttrs v || isList v
            then "json('${toJSON v}')"
            else "'${toString v}'";

        mkUpdates = prefix: attrs: let
            mkUpdate = key: value: ''
                UPDATE storage_sync_data
                SET data = json_set(data, '$.${key}', ${prepare value})
                WHERE ext_id = '${ext.addonId}';
            '';
        in
            attrs
            |> mapAttrsToList (
                k: v: let
                    key =
                        if prefix == ""
                        then k
                        else "${prefix}.${k}";
                in
                    if isAttrs v
                    then mkUpdates key v
                    else [(mkUpdate key v)]
            )
            |> flatten;
    in ''
        INSERT INTO storage_sync_data (ext_id, data)
        SELECT '${ext.addonId}', ${prepare ext.default}
        WHERE NOT EXISTS (SELECT 1 FROM storage_sync_data WHERE ext_id = '${ext.addonId}');

        ${
            ext.settings
            |> mkUpdates ""
            |> concatStringsSep "\n"
        }
    '';

    set-extension-settings = extensions:
        pkgs.writeShellScriptBin "set-extension-settings" ''
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

            ${lib.getExe' pkgs.sqlite "sqlite3"} "$db_file" <<EOF
            ${
                extensions
                |> mapAttrsToList sqlForExtension
                |> concatStringsSep "\n"
            }
            EOF
        '';
in {
    options.extensions = mkOption {
        type = types.attrsOf (types.submodule {
            options = {
                addonId = mkOption {type = types.str;};
                default = mkOption {type = types.attrs;};
                settings = mkOption {type = types.attrs;};
            };
        });
        description = "Declarative way to set firefox extension settings";
        default = {
            vimium = {
                inherit (firefox-addons.vimium.passthru) addonId;
                default.settingsVersion = "2.1.2";
                settings = {
                    searchUrl = "https://search.inetol.net/search?q=";
                    searchEngines = ''
                        w: https://www.wikipedia.org/w/index.php?title=Special:Search&search=%s Wikipedia
                        g: https://www.google.com/search?q=%s Google
                        y: https://youtube.com/results?search_query=%s YouTube
                        gm: https://www.google.com/maps?q=%s Google maps
                        d: https://duckduckgo.com/?q=%s DuckDuckGo
                        az: https://www.amazon.com/s/?field-keywords=%s
                        sxng: https://search.inetol.net/search?q=%s SearXNG
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
            darkreader = {
                inherit (firefox-addons.darkreader.passthru) addonId;
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
    };
    config = cfg: let
        package = set-extension-settings cfg.extensions;
    in {
        hm.home = {
            packages = [package];
            activation.setExtensionSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
                ${
                    config.hm.programs.zenix.profiles
                    |> attrNames
                    |> map (profileName: ''${lib.getExe package} ${profileName}'')
                    |> concatStringsSep "\n"
                }
            '';
        };
    };
}
