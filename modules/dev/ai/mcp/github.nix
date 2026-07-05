{den, ...}: {
    den.aspects.ai.provides.mcp.github = {
        includes = [den.aspects.ai];
        homeManager.my.ai.providers.github.mcpServers.github = {
            type = "http";
            url = "https://api.githubcopilot.com/mcp/";
        };
    };
}
