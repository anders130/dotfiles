{den, ...}: {
    den.aspects.dev = {
        includes = with den.aspects; [
            direnv
            git
            project
            claude
            github-copilot-cli
            sops
        ];
        nixos = {pkgs, ...}: {
            my.nvix.type = "full";
            environment = {
                systemPackages = with pkgs; [
                    tokei
                    nix-melt
                    gemini-cli
                    statix
                    devenv
                ];
                shellAliases.ask = "gemini";
            };
            services.tailscale.enable = true;
        };
    };
}
