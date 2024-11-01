{
    config,
    lib,
    pkgs,
    ...
}: {
    options.bundles.gaming = {
        enable = lib.mkEnableOption "gaming bundle";
    };

    config.modules = lib.mkIf config.bundles.gaming.enable {
        programs.gui.steam.enable = lib.mkDefault true;

        environment.systemPackages = with pkgs.unstable; [
            lutris

            # minecraft
            prismlauncher # minecraft launcher
            jdk17
            jdk8

            # other games
            space-cadet-pinball
            superTuxKart
        ];
    };
}
