{
    config,
    lib,
    pkgs,
    username,
    ...
}: let
    cfg = config.modules.programs.cli.btop;
    package = pkgs.btop.override {
        cudaSupport = config.modules.hardware.nvidia.enable;
        rocmSupport = config.modules.hardware.amdgpu.enable;
    };
in {
    options.modules.programs.cli.btop = {
        enable = lib.mkEnableOption "btop";
    };

    config = lib.mkIf cfg.enable {
        environment.systemPackages = [package];

        home-manager.users.${username}.programs.btop = {
            inherit package;
            enable = true;
            settings = {
                theme_background = false;
                vim_keys = true;
                shown_boxes = "cpu mem net proc gpu0";
                background_update = false;
                update_ms = 1000;
                proc_tree = true;
            };
        };
    };
}
