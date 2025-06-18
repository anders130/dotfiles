{
    lib,
    pkgs,
    username,
    ...
}: let
    inherit (builtins) filter attrValues;
    inherit (lib) generators mergeAttrsList imap1 genAttrs;
    config-dir = "/home/${username}/.config/Nextcloud";
in {
    config = cfg: let
        folder-sync' = filter (item: item.enable) (attrValues cfg.folder-sync);
    in {
        hm.home.packages = [pkgs.nextcloud-client];
        modules.utils.initial-files = {
            enable = true;
            file."${config-dir}/sync-exclude.lst".text = cfg.sync-exclude;
            file."${config-dir}/nextcloud.cfg".text = generators.toINI {} (
                let
                    makeSyncEntry = index: cfg: let
                        prefix = "0\\Folders\\${toString index}\\";
                    in {
                        "${prefix}ignoreHiddenFiles" = cfg.ignoreHiddenFiles;
                        "${prefix}virtualFilesMode" =
                            if cfg.virtualFilesMode
                            then "on"
                            else "off";
                        "${prefix}localPath" = cfg.localPath;
                        "${prefix}targetPath" = cfg.remotePath;
                        "${prefix}paused" = cfg.paused;
                        "${prefix}version" = 2;
                    };
                    sync-entries = mergeAttrsList (imap1 makeSyncEntry folder-sync');
                in {
                    General.clientVersion = "3.13.0";
                    Accounts =
                        {
                            version = 2;
                            "0\\authType" = "webflow";
                            "0\\dav_user" = cfg.user;
                            "0\\displayName" = cfg.user;
                            "0\\url" = cfg.instance-url;
                            "0\\webflow_user" = cfg.user;
                        }
                        // sync-entries;
                }
            );
            directory = let
                dirs' = map (e: e.localPath) folder-sync';
            in
                genAttrs dirs' (key: {});
        };
    };
}
