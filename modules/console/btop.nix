{
    config,
    pkgs,
    username,
    ...
}: {
    home-manager.users.${username}.programs.btop = {
        enable = true;
        package = pkgs.btop.override {
            cudaSupport = config.modules.hardware.nvidia.enable;
            rocmSupport = config.modules.hardware.amdgpu.enable;
        };
        settings = {
            theme_background = false;
            vim_keys = true;
            shown_boxes = "cpu mem net proc gpu0";
            background_update = false;
            update_ms = 1000;
            proc_tree = true;
        };
    };
}
