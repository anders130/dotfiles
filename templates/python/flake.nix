{
    description = "Python development template";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-parts.url = "github:hercules-ci/flake-parts";
    };

    outputs = inputs:
        inputs.flake-parts.lib.mkFlake {inherit inputs;} {
            systems = ["x86_64-linux"];
            perSystem = {
                pkgs,
                system,
                ...
            }: let
                pythonPkgs = pkgs.python312Packages;
                devDeps = with pythonPkgs; [
                    pytest
                    black
                    isort
                ];
                package = inputs.self.packages.${system}.default;
                src = ./.;
                pyproject = {
                    build-system = {
                        requires = ["hatchling"];
                        build-backend = "hatchling.build";
                    };
                    project = {
                        inherit (package) version;
                        name = package.pname;
                        dependencies = map (p: p.pname) inputs.self.packages.${system}.default.dependencies;
                        readme = "README.md";
                        keywords = [];
                        requires-python = ">=3.12";
                    };
                    project.scripts.${package.pname} = "src.main:main";
                    tool.hatch.build.targets.wheel.packages = ["src"];
                };
            in {
                packages.default = pythonPkgs.buildPythonPackage {
                    inherit src;
                    pname = "package";
                    version = "0.1.0";
                    format = "pyproject";
                    build-system = [pythonPkgs.hatchling];

                    dependencies = with pythonPkgs; [
                        # python dependencies
                        numpy
                    ];
                    buidInputs = with pkgs; [
                        # Non python dependencies
                    ];
                };
                devShells.default = pkgs.mkShell {
                    inputsFrom = [package];
                    buildInputs = devDeps;
                    shellHook = ''
                        cat ${pkgs.writers.writeTOML "pyproject.toml" pyproject} > pyproject.toml
                        echo "__version__ = \"${package.version}\"" > src/__init__.py
                    '';
                };
                formatter = pkgs.writeShellApplication {
                    name = "format";
                    runtimeInputs = devDeps;
                    text = ''
                        black .
                        isort . --profile black
                    '';
                };
                checks = let
                    checkDeps = {
                        inherit src;
                        buildInputs = [package devDeps];
                    };
                in {
                    tests = pkgs.runCommand "python-tests" checkDeps ''
                        pytest $src
                        touch $out
                    '';
                    format = pkgs.runCommand "python-format" checkDeps ''
                        black --check $src
                        isort $src --check --diff --known-local-folder "src" --profile "black"
                        touch $out
                    '';
                };
            };
        };
}
