{
    pkgs,
    lib,
    ...
}: let
    caveman = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "caveman";
        version = "1.6.0";

        src = pkgs.fetchFromGitHub {
            owner = "JuliusBrussee";
            repo = "caveman";
            tag = "v${version}";
            hash = "sha256-m7HhCW4fXU5pIYRWVP6cvSYUkDHt8R90D9UI3tT7euk=";
        };

        installPhase = ''
            runHook preInstall
            mkdir -p "$out"
            cp -r . "$out/"
            runHook postInstall
        '';

        meta = with lib; {
            description = "Ultra-compressed communication mode for coding agents";
            homepage = "https://github.com/JuliusBrussee/caveman";
            license = licenses.mit;
            platforms = platforms.all;
        };
    };
    ccstatusline = pkgs.stdenv.mkDerivation rec {
        pname = "ccstatusline";
        version = "2.2.8";

        src = pkgs.fetchurl {
            url = "https://registry.npmjs.org/ccstatusline/-/ccstatusline-${version}.tgz";
            hash = "sha256-4+fZ8yDlKwi+mJIMHEkPgyt8vA0kN3FcaEmUbXU7ctw=";
        };

        nativeBuildInputs = [pkgs.makeWrapper];

        unpackPhase = ''
            tar -xzf $src
            cd package
        '';

        installPhase = ''
            mkdir -p $out/lib/ccstatusline $out/bin
            cp dist/ccstatusline.js $out/lib/ccstatusline/ccstatusline.js
            makeWrapper ${lib.getExe pkgs.nodejs} $out/bin/ccstatusline \
                --add-flags "$out/lib/ccstatusline/ccstatusline.js"
        '';

        meta = {
            description = "A customizable status line formatter for Claude Code CLI";
            homepage = "https://github.com/sirmalloc/ccstatusline";
            license = lib.licenses.mit;
            mainProgram = "ccstatusline";
        };
    };

    sharedSettings = {
        includeCoAuthoredBy = false;
        hooks = {
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
        statusLine = {
            type = "command";
            command = "${lib.getExe ccstatusline}";
        };
    };

    sharedSkills = {
        caveman = "${caveman}/skills/caveman";
        caveman-commit = "${caveman}/skills/caveman-commit";
        caveman-help = "${caveman}/skills/caveman-help";
        caveman-review = "${caveman}/skills/caveman-review";
        caveman-compress = "${caveman}/caveman-compress";
    };

    mkProfileFiles = dir: settings: skills:
        {"${dir}/settings.json".text = builtins.toJSON settings;}
        // lib.mapAttrs' (name: path:
            lib.nameValuePair "${dir}/skills/${name}" {source = path;})
        skills;
in {
    hm.home = {
        shellAliases = let
            claude = "${pkgs.claude-code}/bin/claude";
        in {
            claude-personal = "CLAUDE_CONFIG_DIR=~/.claude-personal ${claude}";
            claude-work = "CLAUDE_CONFIG_DIR=~/.claude-work ${claude}";
        };
        file =
            mkProfileFiles ".claude-personal" sharedSettings sharedSkills
            // mkProfileFiles ".claude-work" sharedSettings sharedSkills;
    };
}
