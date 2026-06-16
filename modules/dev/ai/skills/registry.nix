{
    lib,
    config,
    ...
}: let
    inherit (lib) filterAttrs mapAttrs mapAttrs' nameValuePair optionalAttrs mkOption types;

    repos = config.ai.skillRepos;

    allSkills = src: let
        s = "${src}/skills";
    in
        s
        |> builtins.readDir
        |> filterAttrs (_: type: type == "directory")
        |> mapAttrs' (n: _: nameValuePair n "${s}/${n}");
    someSkills = src: names:
        builtins.listToAttrs (map (n: nameValuePair n "${src}/skills/${n}") names);
in {
    options.ai.skillRepos = mkOption {
        description = "Skill collections, each sourced from a flake input and exposed as a den skill provider.";
        default = {};
        type = types.attrsOf (types.submodule {
            options = {
                src = mkOption {
                    type = types.path;
                    description = "Repo root holding a skills/ directory, typically a flake input with flake = false.";
                };
                select = mkOption {
                    type = types.nullOr (types.listOf types.str);
                    default = null;
                    description = "If set, only these skill dirs are enabled, configurable via my.ai.skills.<name>.";
                };
            };
        });
    };

    config.den.aspects.ai.provides.skills = mapAttrs (
        name: r: {
            homeManager = {
                config,
                lib,
                ...
            }:
                {
                    config.my.ai.providers.${name}.skills =
                        if r.select != null
                        then someSkills r.src config.my.ai.skills.${name}
                        else allSkills r.src;
                }
                // optionalAttrs (r.select != null) {
                    options.my.ai.skills.${name} = lib.mkOption {
                        type = lib.types.listOf lib.types.str;
                        default = r.select;
                        example = r.select ++ ["ai-engineer"];
                        description = "Skills to enable from the ${name} collection (directory names under skills/).";
                    };
                };
        }
    )
    repos;
}
