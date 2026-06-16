{den, ...}: {
    den.aspects.ai.provides.agents.github-copilot = {
        includes = [den.aspects.ai];
        homeManager = {pkgs, ...}: {
            home.packages = [pkgs.llm-agents.copilot-cli];
            my.ai.agents.github-copilot.work.dir = ".agents";
        };
    };
}
