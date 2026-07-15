{
    den.aspects.bottles = {
        homeManager = {pkgs, ...}: {
            home.packages = [(pkgs.bottles.override {removeWarningPopup = true;})];
        };
        # TODO: remove once nixpkgs ships a fixed patool
        nixos.nixpkgs.overlays = [
            (_: prev: {
                pythonPackagesExtensions =
                    prev.pythonPackagesExtensions
                    ++ [
                        (_: pyprev: {patool = pyprev.patool.overridePythonAttrs (_: {doCheck = false;});})
                    ];
            })
        ];
    };
}
