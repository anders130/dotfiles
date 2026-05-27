{
    inputs,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkDefault;
in {
    hm = {
        home.packages = with inputs.self.packages.${pkgs.stdenv.hostPlatform.system}; [
            git
            tmux
        ];
        imports = with inputs.self.modules.homeManager; [
            direnv
            git
            inputs.project.homeManagerModules.default
        ];
        programs.project.enable = mkDefault true;
    };
    modules.programs.cli = {
        claude.enable = mkDefault true;
        github-copilot-cli.enable = mkDefault true;
        nvix = {
            enable = mkDefault true;
            type = mkDefault "full";
        };
        commonTools.enable = mkDefault true;
    };
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
