{den, ...}: {
    den.aspects.ai.provides.agents.gemini = {
        includes = [den.aspects.ai];
        homeManager = {
            config,
            lib,
            pkgs,
            ...
        }: let
            inherit (lib) filterAttrs mapAttrs mapAttrs' nameValuePair optionalAttrs;

            gemini-cli = pkgs.llm-agents.gemini-cli.overrideAttrs (old: {
                npmDeps = old.npmDeps.overrideAttrs (d: {
                    nativeBuildInputs = (d.nativeBuildInputs or []) ++ [pkgs.nodejs];
                });
            });

            instances = config.my.ai.agents.gemini or {};

            toGemini = s:
                if s.type == "stdio"
                then {inherit (s) command args env;}
                else if s.type == "http"
                then {httpUrl = s.url;} // optionalAttrs (s.headers != {}) {inherit (s) headers;}
                else {inherit (s) url;} // optionalAttrs (s.headers != {}) {inherit (s) headers;};
            mcpFor = name: mapAttrs (_: toGemini) (config.my.ai.resolvedMcpServers.gemini.${name} or {});
            withMcp = filterAttrs (name: _: mcpFor name != {}) instances;
        in {
            home = {
                packages = [gemini-cli];
                shellAliases.ask = "gemini";
                file = mapAttrs' (name: agent:
                    nameValuePair "${agent.dir}/settings.json" {
                        text = builtins.toJSON {mcpServers = mcpFor name;};
                    })
                withMcp;
            };
            my.ai.agents.gemini.default.dir = ".gemini";
        };
    };
}
