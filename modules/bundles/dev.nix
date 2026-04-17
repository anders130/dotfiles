{
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkDefault;
in {
    modules.programs.cli = {
        claude.enable = mkDefault true;
        git.enable = mkDefault true;
        nvix = {
            enable = mkDefault true;
            type = mkDefault "full";
        };
        tmux.enable = mkDefault true;
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
