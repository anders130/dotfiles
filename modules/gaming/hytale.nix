{
    flake-file.inputs.hytale-launcher.url = "github:anders130/hytale-launcher-nix";
    dots.gaming.provides.hytale.homeManager = {inputs', ...}: {
        home.packages = [inputs'.hytale-launcher.packages.hytale-launcher];
    };
}
