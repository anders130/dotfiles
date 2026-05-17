{pkgs, ...}: let
    inherit (pkgs.local) caveman;
in {
    modules.programs.cli.claude = {
        skills = {
            caveman = "${caveman}/skills/caveman";
            caveman-commit = "${caveman}/skills/caveman-commit";
            caveman-help = "${caveman}/skills/caveman-help";
            caveman-review = "${caveman}/skills/caveman-review";
            caveman-compress = "${caveman}/caveman-compress";
        };
        settings.hooks = {
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
