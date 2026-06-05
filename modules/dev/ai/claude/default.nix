{
    den.aspects.claude.homeManager = {
        config,
        lib,
        pkgs,
        ...
    }: let
        inherit (lib) mapAttrs' mapAttrsToList mkMerge mkOption nameValuePair types;

        mkProfileFiles = dir: settings: skills:
            {"${dir}/settings.json".text = builtins.toJSON settings;}
            // mapAttrs' (name: path: nameValuePair "${dir}/skills/${name}" {source = path;})
            skills;

        cfg = config.my.programs.claude;
    in {
        options.my.programs.claude = {
            skills = mkOption {
                type = types.attrsOf types.str;
                default = {};
                description = "Skill name to store path mappings, symlinked into each profile's skills/ dir";
            };
            profiles = mkOption {
                type = types.attrsOf types.str;
                default = {
                    personal = ".claude-personal";
                    work = ".claude-work";
                };
                description = "Claude profile name to config directory (relative to ~) mappings";
            };
            settings = mkOption {
                type = types.attrs;
                default = {};
                description = "Freeform settings merged into each profile's settings.json";
            };
        };
        config = {
            my.programs.claude.settings.includeCoAuthoredBy = false;
            home = {
                shellAliases = let
                    claude = "${pkgs.claude-code}/bin/claude";
                in
                    mapAttrs' (name: dir:
                        nameValuePair "claude-${name}" "CLAUDE_CONFIG_DIR=~/${dir} ${claude}")
                    cfg.profiles;
                file = mkMerge (mapAttrsToList (_: dir:
                    mkProfileFiles dir cfg.settings cfg.skills)
                cfg.profiles);
            };
        };
    };
}
