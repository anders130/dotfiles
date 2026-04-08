inputs: final: prev: let
    unstable = import inputs.nixpkgs-unstable {
        inherit (prev) config;
        inherit (prev.stdenv.hostPlatform) system;
    };
in {
    terraria-server = unstable.terraria-server.overrideAttrs (old: {
        version = "1.4.5.6";
        src = prev.fetchurl {
            url = "https://terraria.org/api/download/pc-dedicated-server/terraria-server-1456.zip";
            hash = "sha256-11xFWsIX/TQ0RIyPglHBNH8IdahcQ4WJ3HG1V3d+kVU=";
        };
    });
}
