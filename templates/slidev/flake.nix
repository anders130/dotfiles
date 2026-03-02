{
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
    };
    outputs = inputs: let
        system = "x86_64-linux";
        pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {
        devShells.${system}.default = pkgs.mkShell {
            buildInputs = with pkgs; [
                nodejs
                pnpm
                chromium
            ];
            env.BROWSER = "chromium";
        };
    };
}
