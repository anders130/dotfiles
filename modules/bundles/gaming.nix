{
    inputs,
    lib,
    pkgs,
    ...
}: {
    imports = [
        inputs.self.modules.nixos.steam
    ];
    modules.programs.gui = {
        prismlauncher.enable = lib.mkDefault true;
    };

    environment.systemPackages = with pkgs; [
        lutris
        r2modman

        # other games
        space-cadet-pinball
        supertuxkart
    ];
}
