{
    inputs,
    pkgs,
    ...
}: {
    my.nvix.type = "full";
    hm.imports = with inputs.self.modules.homeManager; [
        direnv
        git
        project
        claude
        github-copilot-cli
        sops
    ];
    hm.home.packages = with inputs.self.packages.${pkgs.stdenv.hostPlatform.system}; [
        git
        tmux
    ];
    environment = {
        systemPackages = with pkgs; [
            tokei
            nix-melt
            gemini-cli
            statix
            devenv
        ];
        shellAliases = {
            ask = "gemini";
        };
    };
}
