inputs: rec {
    allowMissingOverlay = final: prev: {
        makeModulesClosure = x: prev.makeModulesClosure (x // {allowMissing = true;});
    };

    all-channels = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
            inherit (prev) system;
            config = {
                allowUnfree = true;
                allowUnsupportedSystem = true;
                permittedInsecurePackages = [];
            };
        };

        local = import ./pkgs {
            inherit (prev) system;
            pkgs = final;
        };
    };

    evdiFix = final: prev: {
        linuxPackages_latest =
            prev.linuxPackages_latest.extend
            (lpfinal: lpprev: {
                evdi = lpprev.evdi.overrideAttrs (efinal: eprev: {
                    version = "1.14.6-git";
                    src = prev.fetchFromGitHub {
                        owner = "DisplayLink";
                        repo = "evdi";
                        rev = "b0fdc340791d01e12796f2df6b62cde576ca4177";
                        sha256 = "sha256-/XIWacrsB7qBqlLUwIGuDdahvt2dAwiK7dauFaYh7lU=";
                    };
                });
            });
        displaylink = prev.displaylink.override {
            inherit (final.linuxPackages_latest) evdi;
        };
    };

    default = inputs.nixpkgs.lib.composeManyExtensions [
        allowMissingOverlay
        all-channels
        inputs.nix-minecraft.overlay
        evdiFix
    ];
}
