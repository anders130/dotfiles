inputs: final: prev: {
    terraria-server = inputs.nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.terraria-server.overrideAttrs (old: {
        version = "1.4.5.6";
        src = prev.fetchurl {
            url = "https://terraria.org/api/download/pc-dedicated-server/terraria-server-1456.zip";
            hash = "sha256-11xFWsIX/TQ0RIyPglHBNH8IdahcQ4WJ3HG1V3d+kVU=";
        };
    });
}
