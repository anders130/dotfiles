{
    hm.programs.direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
        config.global.warn_timeout = 0;
    };
}
