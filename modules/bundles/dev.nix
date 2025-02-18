{lib, ...}: let
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
}
