{
    flake.modules.homeManager.nextcloud = {
        config,
        pkgs,
        lib,
        ...
    }: let
        inherit (builtins) filter attrValues;
        inherit (lib) generators mergeAttrsList imap1 genAttrs mkIf;
        cfg = config.programs.nextcloud;
        folder-sync' = filter (item: item.enable) (attrValues cfg.folder-sync);
    in {
        config = mkIf cfg.enable {
            home.packages = [pkgs.nextcloud-client];
            modules.initial-files = {
                file = let
                    config-dir = "${config.home.homeDirectory}/.config/Nextcloud";
                in {
                    "${config-dir}/sync-exclude.lst".text = cfg.sync-exclude;
                    "${config-dir}/nextcloud.cfg".text = generators.toINI {} (
                        let
                            makeSyncEntry = index: syncCfg: let
                                prefix = "0\\Folders\\${toString index}\\";
                            in {
                                "${prefix}ignoreHiddenFiles" = syncCfg.ignoreHiddenFiles;
                                "${prefix}virtualFilesMode" =
                                    if syncCfg.virtualFilesMode
                                    then "on"
                                    else "off";
                                "${prefix}localPath" = syncCfg.localPath;
                                "${prefix}targetPath" = syncCfg.remotePath;
                                "${prefix}paused" = syncCfg.paused;
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
                };

                directory = let
                    dirs' = map (e: e.localPath) folder-sync';
                in
                    genAttrs dirs' (key: {});
            };
        };
    };
}
