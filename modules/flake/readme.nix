{
    lib,
    config,
    ...
}: let
    flakeCfg = config;
in {
    options.readmeLib = lib.mkOption {
        internal = true;
        readOnly = true;
        type = lib.types.raw;
        default = let
            repoUrl = "https://github.com/anders130/dotfiles";
        in {
            cloneRepo = ''
                ```bash
                git clone ${repoUrl}
                cd dotfiles
                ```
            '';
            mkSectionType = l:
                l.types.submodule {
                    options.title = l.mkOption {type = l.types.str;};
                    options.content = l.mkOption {type = l.types.lines;};
                };
            join = parts: builtins.concatStringsSep "\n\n" (builtins.filter (x: x != "") parts);
            heading = level: s: "${level} ${s.title}\n\n${s.content}";
        };
    };
    config.perSystem = {
        pkgs,
        lib,
        config,
        ...
    }: let
        inherit (flakeCfg.readmeLib) mkSectionType join heading;
        inherit (builtins) concatStringsSep;
        inherit (lib) mapAttrs';

        sectionType = mkSectionType lib;

        docType = lib.types.submodule {
            options = {
                title = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                };
                intro = lib.mkOption {
                    type = lib.types.lines;
                    default = "";
                };
                sections = lib.mkOption {
                    type = lib.types.listOf sectionType;
                    default = [];
                };
                usage = lib.mkOption {
                    type = lib.types.listOf sectionType;
                    default = [];
                    description = "Subsections bundled under a single '## Usage' heading.";
                };
            };
        };

        writeMarkdown = text:
            pkgs.runCommand "README.md" {nativeBuildInputs = [pkgs.prettier];} ''
                prettier --parser markdown ${pkgs.writeText "readme" text} > $out
            '';

        render = doc:
            writeMarkdown (join (
                [
                    (lib.optionalString (doc.title != "") "# ${doc.title}")
                    doc.intro
                ]
                ++ map (heading "##") doc.sections
                ++ lib.optional (doc.usage != []) ''
                    ## Usage

                    ${concatStringsSep "\n\n" (map (heading "###") doc.usage)}
                ''
            ));
    in {
        options = {
            rootReadme = lib.mkOption {
                type = docType;
                default = {};
                description = "The root README.md, generated at the repo root.";
            };
            readmeFiles = lib.mkOption {
                type = lib.types.attrsOf docType;
                default = {};
                description = "Additional READMEs to generate, keyed by output path.";
            };
        };

        config = {
            rootReadme = {
                title = "My [NixOS](https://nixos.org/) Configuration";
                intro = ''
                    Built with [Nix flakes](https://wiki.nixos.org/wiki/Flakes) and the [den](https://github.com/denful/den) framework.

                    - [./hosts](./hosts): Host configurations.
                    - [./modules](./modules): Modules shared between hosts.
                    - [./templates](./templates): Templates for flake-based projects.
                '';
            };

            files.file =
                mapAttrs' (path: doc: lib.nameValuePair path {source = render doc;}) config.readmeFiles
                // {"README.md".source = render config.rootReadme;};
        };
    };
}
