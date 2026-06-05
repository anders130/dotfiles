{
    den.aspects.initial-files.homeManager = {
        config,
        lib,
        ...
    }: let
        cfg = config.modules.initial-files;
    in {
        options.modules.initial-files = {
            file = lib.mkOption {
                type = lib.types.attrsOf (
                    lib.types.submodule {
                        options.text = lib.mkOption {
                            type = lib.types.str;
                            description = "Text content of the file.";
                        };
                    }
                );
                default = {};
                description = "Files to create if they don't already exist.";
            };

            directory = lib.mkOption {
                type = lib.types.attrsOf (lib.types.submodule {});
                default = {};
                description = "Directories to create if they don't already exist.";
            };
        };
        config = lib.mkIf (cfg.file != {} || cfg.directory != {}) {
            home.activation.createInitialFiles = lib.hm.dag.entryAfter ["writeBoundary"] (
                let
                    fileCommands = lib.concatStringsSep "\n" (
                        lib.mapAttrsToList (
                            path: opts: ''
                                if [ ! -e "${path}" ]; then
                                    mkdir -p "$(dirname "${path}")"
                                    cat > "${path}" << 'INITIAL_FILE_EOF'
                                ${opts.text}
                                INITIAL_FILE_EOF
                                fi
                            ''
                        )
                        cfg.file
                    );
                    dirCommands = lib.concatStringsSep "\n" (
                        lib.mapAttrsToList (
                            path: _: ''
                                if [ ! -d "${path}" ]; then
                                    mkdir -p "${path}"
                                fi
                            ''
                        )
                        cfg.directory
                    );
                in ''
                    ${fileCommands}
                    ${dirCommands}
                ''
            );
        };
    };
}
