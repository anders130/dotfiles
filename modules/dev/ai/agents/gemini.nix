{den, ...}: {
    den.aspects.ai.provides.agents.gemini = {
        includes = [den.aspects.ai];
        homeManager = {pkgs, ...}: let
            gemini-cli = pkgs.llm-agents.gemini-cli.overrideAttrs (old: {
                npmDeps = old.npmDeps.overrideAttrs (d: {
                    nativeBuildInputs = (d.nativeBuildInputs or []) ++ [pkgs.nodejs];
                });
            });
        in {
            home = {
                packages = [gemini-cli];
                shellAliases.ask = "gemini";
            };
            my.ai.agents.gemini.default.dir = ".gemini";
        };
    };
}
