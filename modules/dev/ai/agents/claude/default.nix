{den, ...}: {
    den.aspects.ai.provides.agents.claude = {
        includes = [den.aspects.ai];
        homeManager = {
            config,
            lib,
            pkgs,
            ...
        }: let
            inherit (lib) filterAttrs mapAttrs mapAttrs' mkOption nameValuePair optionalAttrs types;

            instances = config.my.ai.agents.claude or {};
            claude = "${pkgs.llm-agents.claude-code}/bin/claude";

            toClaude = s:
                if s.type == "stdio"
                then {
                    type = "stdio";
                    inherit (s) command args env;
                }
                else {inherit (s) type url;} // optionalAttrs (s.headers != {}) {inherit (s) headers;};
            mcpFor = name: mapAttrs (_: toClaude) (config.my.ai.resolvedMcpServers.claude.${name} or {});
            withMcp = filterAttrs (name: _: mcpFor name != {}) instances;
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
                    activation = mapAttrs' (name: agent: let
                        servers = pkgs.writeText "claude-mcp-${name}.json" (builtins.toJSON (mcpFor name));
                    in
                        nameValuePair "claudeMcp-${name}" (lib.hm.dag.entryAfter ["writeBoundary"] ''
                            f="${config.home.homeDirectory}/${agent.dir}/.claude.json"
                            mkdir -p "$(dirname "$f")"
                            [ -e "$f" ] || echo '{}' > "$f"
                            ${pkgs.jq}/bin/jq --slurpfile m ${servers} '.mcpServers = $m[0]' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
                        ''))
                    withMcp;
                };
            };
        };
    };
}
