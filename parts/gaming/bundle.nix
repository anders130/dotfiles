{inputs, ...}: let
    inherit (inputs.self) modules;
in {
    flake.modules = {
        nixos.gaming = {
            imports = [modules.nixos.steam];
            home-manager.sharedModules = [modules.homeManager.gaming];
        };
        homeManager.gaming = {pkgs, ...}: {
            imports = [modules.homeManager.minecraft];
            home.packages = with pkgs; [
                lutris
                r2modman

                # other games
                space-cadet-pinball
                supertuxkart
            ];
        };
    };
}
