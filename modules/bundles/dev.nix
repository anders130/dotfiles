{
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkDefault;
in {
    modules.programs.cli = {
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
            inputs.nix-melt.default
            gemini-cli
            statix
        ];
        shellAliases = {
            ask = "gemini";
        };
    };
}
