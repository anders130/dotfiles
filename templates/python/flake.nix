{
    description = "Python development template";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        utils.url = "github:numtide/flake-utils";
    };

    outputs = {
        self,
        nixpkgs,
        utils,
        ...
    }:
        utils.lib.eachDefaultSystem (system: let
            pkgs = import nixpkgs {inherit system;};
            pythonPkgs = pkgs.python312Packages;
        in {
            packages.default = pythonPkgs.buildPythonPackage {
                pname = "package";
                version = "0.1.0";
                format = "pyproject";

                src = ./.;

                build-system = [pythonPkgs.hatchling];

                dependencies = with pythonPkgs; [
                    # Python dependencies
                    pytest
                    numpy
                ];

                buidInputs = with pkgs; [
                    # Non Python dependencies
                ];
            };

            devShells.default = pkgs.mkShell {
                inputsFrom = [
                    self.packages.${system}.default
                ];
            };

            checks.tests =
                pkgs.runCommand "python-tests" {
                    buildInputs = [self.packages.${system}.default];
                    src = ./.;
                } ''
                    cp -r $src/* .
                    pytest
                    echo "Test run complete" > $out
                '';
        });
}
