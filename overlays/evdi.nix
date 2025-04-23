inputs: final: prev: {
    linuxPackages_latest = prev.linuxPackages_latest.extend
    (lpfinal: lpprev: {
        evdi = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.linuxPackages_latest.evdi;
    });
    displaylink = prev.displaylink.override {
        inherit (final.linuxPackages_latest) evdi;
    };
}
