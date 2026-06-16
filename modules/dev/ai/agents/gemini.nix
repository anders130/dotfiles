{den, ...}: {
    den.aspects.ai.provides.agents.gemini = {
        includes = [den.aspects.ai];
        homeManager = {pkgs, ...}: {
            home = {
                packages = [pkgs.llm-agents.gemini-cli];
                shellAliases.ask = "gemini";
            };
            my.ai.agents.gemini.default.dir = ".gemini";
        };
    };
}
