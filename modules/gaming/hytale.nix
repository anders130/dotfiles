{inputs, ...}: {
    flake-file.inputs.hytale-launcher.url = "github:anders130/hytale-launcher-nix";
    flake.modules.homeManager.hytale = {pkgs, ...}: {
        home.packages = [inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.hytale-launcher];
    };
}
