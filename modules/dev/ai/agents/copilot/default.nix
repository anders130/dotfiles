{den, ...}: {
    den.aspects.ai.provides.agents.github-copilot = {
        includes = [den.aspects.ai];
        homeManager = {
            config,
            lib,
            pkgs,
            ...
        }: let
            inherit (lib) mapAttrs mkIf mkOption optionalAttrs types;

            toCopilot = s:
                if s.type == "stdio"
                then {
                    type = "local";
                    inherit (s) command args env;
                }
                else {inherit (s) type url;} // optionalAttrs (s.headers != {}) {inherit (s) headers;};
            servers = mapAttrs (_: toCopilot) (config.my.ai.resolvedMcpServers.github-copilot.work or {});
        in {
            options.my.programs.copilot.package = mkOption {
                type = types.package;
                default = pkgs.llm-agents.copilot-cli;
                description = "copilot-cli package to install (overridable for theming).";
            };
            config = {
                home = {
                    packages = [config.my.programs.copilot.package];
                    file.".copilot/mcp-config.json" = mkIf (servers != {}) {
                        text = builtins.toJSON {mcpServers = servers;};
                    };
                };
                my.ai.agents.github-copilot.work.dir = ".agents";
            };
        };
    };
}
