{
    config,
    lib,
    ...
}
: {
    options.modules.theming.plymouth = {
        enable = lib.mkEnableOption "plymouth";
    };

    config.boot = lib.mkIf config.modules.theming.plymouth.enable {
        plymouth.enable = true;
        kernelParams = ["quiet" "splash"];
    };
}
