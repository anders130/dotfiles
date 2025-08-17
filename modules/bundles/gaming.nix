{
    lib,
    pkgs,
    ...
}: {
    modules.programs.gui = {
        prismlauncher.enable = lib.mkDefault true;
        steam.enable = lib.mkDefault true;
    };

    environment.systemPackages = with pkgs; [
        lutris
        r2modman

        # other games
        space-cadet-pinball
        superTuxKart
    ];
}
