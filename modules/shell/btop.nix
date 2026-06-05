{
    # global aspect (den.default) — stays a my.* option (parametric host reads
    # only work for host-included aspects, not den.default-global ones).
    den.aspects.btop.homeManager = {
        config,
        lib,
        pkgs,
        ...
    }: {
        options.my.btop.rocmSupport = lib.mkEnableOption "ROCm support for btop";
        config.programs.btop = {
            enable = true;
            package = pkgs.btop.override {rocmSupport = config.my.btop.rocmSupport;};
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
