{den, ...}: {
    den.aspects.ai.provides.agents.claude = {
        includes = [den.aspects.ai];
        homeManager = {
            config,
            lib,
            pkgs,
            ...
        }: let
            inherit (lib) mapAttrs' mkOption nameValuePair types;

            instances = config.my.ai.agents.claude or {};
            claude = "${pkgs.llm-agents.claude-code}/bin/claude";
        in {
            options.my.programs.claude.settings = mkOption {
                type = types.attrs;
                default = {};
                description = "Freeform settings merged into every claude instance's settings.json.";
            };
            config = {
                my = {
                    ai.agents.claude.personal.dir = ".claude-personal";
                    programs.claude.settings.includeCoAuthoredBy = false;
                };
                home = {
                    shellAliases = mapAttrs' (name: agent:
                        nameValuePair "claude-${name}" "CLAUDE_CONFIG_DIR=~/${agent.dir} ${claude}")
                    instances;
                    file = mapAttrs' (_: agent:
                        nameValuePair "${agent.dir}/settings.json" {
                            text = builtins.toJSON config.my.programs.claude.settings;
                        })
                    instances;
                };
            };
        };
    };
}
