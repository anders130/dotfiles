{inputs, ...}: {
    flake-file.inputs.spec-kit-extensions = {
        url = "github:RbBtSn0w/spec-kit-extensions";
        flake = false;
    };

    perSystem = {
        pkgs,
        self',
        ...
    }: {
        packages.spec-kit-skills = pkgs.runCommand "spec-kit-skills" {
            nativeBuildInputs = [self'.packages.spec-kit-patched pkgs.git pkgs.gnused];
            superb = inputs.spec-kit-extensions;
        } ''
            export HOME=$(mktemp -d)
            cd "$HOME"

            specify init --here --integration claude --ignore-agent-tools --force 2>/dev/null
            specify extension add "$superb/superpowers-bridge" --dev --force 2>/dev/null
            specify integration upgrade claude --force 2>/dev/null

            find .claude/skills -name "SKILL.md" | xargs sed -i \
                's|\.specify/scripts/bash/|~/.specify/scripts/bash/|g;
                 s|\.specify/extensions/\([^/]*\)/scripts/bash/|~/.specify/extensions/\1/scripts/bash/|g'

            mkdir -p "$out"
            cp -r .claude/skills "$out/skills"
            cp -r .specify/scripts "$out/scripts"
            cp -r .specify/templates "$out/templates"
            cp -r .specify/extensions "$out/extensions"

            find "$out" -name "*.sh" | xargs chmod +x
        '';
    };
}
