{den, ...}: {
    den.aspects.dev = {
        includes = with den.aspects; [
            ai.provides.agents.claude
            ai.provides.agents.gemini
            ai.provides.tools.spec-kit
            direnv
            git
            project
            sops
        ];
        nixos = {pkgs, ...}: {
            my.nvix.type = "full";
            environment.systemPackages = with pkgs; [
                tokei
                nix-melt
                statix
                devenv
            ];
            services.tailscale.enable = true;
        };
    };
}
