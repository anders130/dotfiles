{
    inputs,
    pkgs,
    ...
}: {
    imports = [
        inputs.self.modules.nixos.steam
    ];
    hm.imports = [
        inputs.self.modules.homeManager.minecraft
    ];

    environment.systemPackages = with pkgs; [
        lutris
        r2modman

        # other games
        space-cadet-pinball
        supertuxkart
    ];
}
