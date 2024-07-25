{
    config,
    lib,
    ...
}
: {
    options.modules.theming.plymouth = {
        enable = lib.mkEnableOption "plymouth";
    };

    config = lib.mkIf config.modules.theming.plymouth.enable {
        boot = {
            plymouth.enable = true;
            kernelParams = ["quiet" "splash"];
        };
    };
}
