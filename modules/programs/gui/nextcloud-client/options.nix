{lib, ...}: let
    inherit (lib) mkOption mkDefault types literalExpression;
in {
    options = {
        startInBackground = mkOption {
            type = types.bool;
            description = "Whether to start the Nextcloud client in the background.";
            default = false;
        };

        instance-url = mkOption {
            type = types.strMatching "^http.*";
            example = "https://nextcloud.example.com";
            description = "URL of the Nextcloud instance where the files are stored.";
        };

        user = mkOption {
            type = types.str;
            example = "francis";
            description = "Username to do the syncronisation for";
        };

        folder-sync = mkOption {
            default = {};
            example = literalExpression ''
                "/Documents" = {
                    localPath = "$'{config.home.homeDirectory}/nextcloud/Docs";
                    ignoreHiddenFiles = false;
                    paused = true;
                };
                "/Pictures" = {
                    localPath = "$'{config.home.homeDirectory}/nextcloud/Pics";
                    ignoreHiddenFiles = false;
                };
            '';
            description = "File groups that should be synchronised with Nextcloud.";
            type = with types;
                attrsOf (
                    submodule (
                        {name, ...}: {
                            options = {
                                enable = mkOption {
                                    type = types.bool;
                                    default = true;
                                    description = ''
                                        Whether this entry should be generated.
                                        This option allows specific entries to be disabled.
                                    '';
                                };
                                paused = mkOption {
                                    type = types.bool;
                                    default = false;
                                    description = "Whether the synchronisation should initially start out paused.";
                                };
                                localPath = mkOption {
                                    type = types.path;
                                    description = ''
                                        The location in the local file system where the remote
                                        files should be downloaded to.
                                    '';
                                };
                                remotePath = mkOption {
                                    type = types.str;
                                    description = "The remote location where the files are orginating from or are uploaded to.";
                                };
                                virtualFilesMode = mkOption {
                                    default = false;
                                    type = types.bool;
                                    description = ''
                                        If true, files are not downloaded until accessed.
                                        Might only work properly under Windows.
                                    '';
                                };
                                ignoreHiddenFiles = mkOption {
                                    default = true;
                                    type = types.bool;
                                    description = ''Whether to sync hidden files.'';
                                };
                            };
                            config.remotePath = mkDefault name;
                        }
                    )
                );
        };

        sync-exclude = mkOption {
            type = types.lines;
            description = "Lists glob patterns to ignore when syncing.";
            default = ''
                *~
                ~$*
                .~lock.*
                ~*.tmp
                ]*.~*
                ]Icon\r*
                ].DS_Store
                ].ds_store
                *.textClipping
                ._*
                ]Thumbs.db
                ]photothumb.db
                System Volume Information
                .*.sw?
                .*.*sw?
                ].TemporaryItems
                ].Trashes
                ].DocumentRevisions-V100
                ].Trash-*
                .fseventd
                .apdisk
                .Spotlight-V100
                .directory
                *.part
                *.filepart
                *.crdownload
                *.kate-swp
                *.gnucash.tmp-*
                .synkron.*
                .sync.ffs_db
                .symform
                .symform-store
                .fuse_hidden*
                *.unison
                .nfs*
                My Saved Places.
                \#*#
                *.sb-*
            '';
        };
    };
}
