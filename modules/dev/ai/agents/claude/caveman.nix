{den, ...}: {
    den.aspects.ai.provides.agents.claude = {
        includes = [den.aspects.ai.provides.skills.caveman];
        homeManager.my.programs.claude.settings.hooks = {
            SessionStart = [
                {
                    hooks = [
                        {
                            type = "command";
                            command = "if [ -f ~/.claude/hooks/caveman-activate.js ]; then node ~/.claude/hooks/caveman-activate.js; fi";
                            timeout = 5;
                            statusMessage = "Loading caveman mode...";
                        }
                    ];
                }
            ];
            UserPromptSubmit = [
                {
                    hooks = [
                        {
                            type = "command";
                            command = "if [ -f ~/.claude/hooks/caveman-mode-tracker.js ]; then node ~/.claude/hooks/caveman-mode-tracker.js; fi";
                            timeout = 5;
                            statusMessage = "Tracking caveman mode...";
                        }
                    ];
                }
            ];
        };
    };
}
