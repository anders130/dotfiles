{den, ...}: {
    den.aspects.ai.includes = with den.aspects.ai.provides; [
        skills.caveman
        skills.superpowers
        skills.antigravity
        tools.spec-kit
    ];
    den.aspects.ai.homeManager = {
        config,
        lib,
        ...
    }: let
        inherit (lib) attrNames concatLists concatMap foldl' mapAttrs' mapAttrsToList mkMerge mkOption nameValuePair types;
        cfg = config.my.ai;

        instances =
            cfg.agents
            |> mapAttrsToList (program: mapAttrsToList (name: agent: agent // {label = "${program}.${name}";}))
            |> concatLists;
        skillsFor = agent:
            (
                if agent.providers == "all"
                then attrNames cfg.providers
                else agent.providers
            )
            |> foldl' (acc: name: acc // (cfg.providers.${name}.skills or {})) {};
        linksFor = agent:
            skillsFor agent
            |> mapAttrs' (skill: path: nameValuePair "${agent.dir}/skills/${skill}" {source = path;});
        checkFor = agent:
            if agent.providers == "all"
            then []
            else
                agent.providers
                |> map (provider: {
                    assertion = cfg.providers ? ${provider};
                    message = "my.ai.agents.${agent.label}.providers: unknown provider \"${provider}\". Available: ${toString (attrNames cfg.providers)}.";
                });
    in {
        options.my.ai = {
            providers = mkOption {
                default = {};
                type = types.attrsOf (types.submodule {
                    options.skills = mkOption {
                        type = types.attrsOf types.str;
                        default = {};
                    };
                });
            };
            agents = mkOption {
                default = {};
                type = types.attrsOf (types.attrsOf (types.submodule {
                    options = {
                        dir = mkOption {
                            type = types.str;
                            example = ".claude-personal";
                        };
                        providers = mkOption {
                            type = types.either (types.enum ["all"]) (types.listOf types.str);
                            default = "all";
                            example = ["caveman" "spec-kit"];
                            description = "Providers to enable for this instance: \"all\" or an explicit list of provider names.";
                        };
                    };
                }));
            };
        };
        config = {
            assertions = concatMap checkFor instances;
            home.file = mkMerge (map linksFor instances);
        };
    };
}
