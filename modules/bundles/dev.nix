{lib, ...}: {
    modules.programs.cli = {
        git.enable = lib.mkDefault true;
        nvix = {
            enable = lib.mkDefault true;
            type = lib.mkDefault "full";
        };
        tmux.enable = lib.mkDefault true;
        commonTools.enable = lib.mkDefault true;
    };
}
