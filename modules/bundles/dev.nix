{
    inputs,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkDefault;
in {
    hm = {config, ...}: {
        home.packages = with inputs.self.packages.${pkgs.stdenv.hostPlatform.system}; [
            git
            tmux
        ];
        imports = with inputs.self.modules.homeManager; [
            direnv
            git
            inputs.project.homeManagerModules.default
            claude
            github-copilot-cli
        ];
        programs.project = {
            enable = mkDefault true;
            palette = with config.lib.stylix.colors.withHashtag; [
                base00
                base08
                base0B
                base0A
                base0D
                base0E
                base0C
                base05
                base03
                base09
                base01
                base02
                base0F
                base06
                base07
                base04
            ];
        };
    };
    modules.programs.cli = {
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
