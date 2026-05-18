{pkgs, ...}: let
    inherit (pkgs.local) caveman;
in {
    modules.programs.cli.claude = {
        skills = {
            cavecrew = "${caveman}/skills/cavecrew";
            caveman = "${caveman}/skills/caveman";
            caveman-commit = "${caveman}/skills/caveman-commit";
            caveman-compress = "${caveman}/caveman-compress";
            caveman-help = "${caveman}/skills/caveman-help";
            caveman-review = "${caveman}/skills/caveman-review";
            caveman-stats = "${caveman}/skills/caveman-stats";
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
