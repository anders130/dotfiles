{den, ...}: {
    den.aspects.ai.provides.agents.github-copilot = {
        includes = [den.aspects.ai];
        homeManager = {
            config,
            lib,
            pkgs,
            ...
        }: let
            inherit (lib) mapAttrs mkIf optionalAttrs;

            toCopilot = s:
                if s.type == "stdio"
                then {
                    type = "local";
                    inherit (s) command args env;
                }
                else {inherit (s) type url;} // optionalAttrs (s.headers != {}) {inherit (s) headers;};
            servers = mapAttrs (_: toCopilot) (config.my.ai.resolvedMcpServers.github-copilot.work or {});
        in {
            home = {
                packages = [pkgs.llm-agents.copilot-cli];
                file.".copilot/mcp-config.json" = mkIf (servers != {}) {
                    text = builtins.toJSON {mcpServers = servers;};
                };
            };
            my.ai.agents.github-copilot.work.dir = ".agents";
        };
    };
}
