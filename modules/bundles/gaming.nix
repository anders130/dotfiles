{
    lib,
    pkgs,
    ...
}: {
    modules.programs.gui.steam.enable = lib.mkDefault true;

    environment.systemPackages = with pkgs; [
        lutris

        # minecraft
        prismlauncher # minecraft launcher
        jdk17
        jdk8

        # other games
        space-cadet-pinball
        superTuxKart
    ];
}
