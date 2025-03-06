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

        # other games
        space-cadet-pinball
        superTuxKart
    ];
}
