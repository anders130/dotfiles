{
    config,
    lib,
    ...
}
: {
    options = {
        modules.plymouth.enable = lib.mkEnableOption "plymouth";
    };

    config = lib.mkIf config.modules.plymouth.enable {
        boot = {
            plymouth.enable = true;
            kernelParams = ["quiet" "splash"];
        };
    };
}
