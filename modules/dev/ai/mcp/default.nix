{
    den.aspects.ai.homeManager = {
        config,
        lib,
        ...
    }: let
        inherit (lib) attrNames foldl' mapAttrs mkOption types;
        cfg = config.my.ai;

        providersFor = agent:
            if agent.providers == "all"
            then attrNames cfg.providers
            else agent.providers;
        mcpServersFor = agent:
            providersFor agent
            |> foldl' (acc: name: acc // (cfg.providers.${name}.mcpServers or {})) {};
    in {
        options.my.ai = {
            providers = mkOption {
                type = types.attrsOf (types.submodule {
                    options.mcpServers = mkOption {
                        default = {};
                        type = types.attrsOf (types.submodule {
                            options = {
                                type = mkOption {
                                    type = types.enum ["stdio" "http" "sse"];
                                    default = "stdio";
                                };
                                command = mkOption {
                                    type = types.nullOr types.str;
                                    default = null;
                                };
                                args = mkOption {
                                    type = types.listOf types.str;
                                    default = [];
                                };
                                env = mkOption {
                                    type = types.attrsOf types.str;
                                    default = {};
                                };
                                url = mkOption {
                                    type = types.nullOr types.str;
                                    default = null;
                                };
                                headers = mkOption {
                                    type = types.attrsOf types.str;
                                    default = {};
                                };
                            };
                        });
                    };
                });
            };
            resolvedMcpServers = mkOption {
                internal = true;
                default = {};
                type = types.attrsOf (types.attrsOf types.attrs);
            };
        };
        config.my.ai.resolvedMcpServers =
            mapAttrs (_: insts: mapAttrs (_: mcpServersFor) insts) cfg.agents;
    };
}
