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
            devDeps = with pythonPkgs; [
                pytest
                black
                isort
            ];
        in {
            packages.default = pythonPkgs.buildPythonPackage {
                pname = "package";
                version = "0.1.0";
                format = "pyproject";

                src = ./.;

                build-system = [pythonPkgs.hatchling];

                dependencies = with pythonPkgs; [
                    numpy
                ];

                buidInputs = with pkgs; [
                    # Non Python dependencies
                ];
            };

            devShells.default = pkgs.mkShell {
                inputsFrom = [self.packages.${system}.default];
                buildInputs = devDeps;
            };

            checks = let
                checkDeps = {
                    buildInputs = [self.packages.${system}.default devDeps];
                    src = ./.;
                };
            in {
                tests = pkgs.runCommand "python-tests" checkDeps ''
                    pytest $src
                    touch $out
                '';

                format = pkgs.runCommand "python-format" checkDeps ''
                    black --check $src
                    isort --check-only $src
                    touch $out
                '';
            };
        });
}
