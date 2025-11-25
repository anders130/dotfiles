{
    description = "Basic dev environment";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        flake-parts.url = "github:hercules-ci/flake-parts";
    };

    outputs = inputs:
        inputs.flake-parts.lib.mkFlake {inherit inputs;} {
            systems = ["x86_64-linux"];
            perSystem = {pkgs, ...}: {
                devShells.default = pkgs.mkShell {
                    buildInputs = with pkgs; [
                        # add your packages here
                    ];
                };
            };
        };
}
