{
    config,
    lib,
    ...
}: {
    options.bundles.dev = {
        enable = lib.mkEnableOption "dev bundle";
    };

    config.modules = lib.mkIf config.bundles.dev.enable {
        programs.cli = {
            git.enable = lib.mkDefault true;
            nixvim.enable = lib.mkDefault true;
            tmux.enable = lib.mkDefault true;
            commonTools.enable = lib.mkDefault true;
        };
    };
}
