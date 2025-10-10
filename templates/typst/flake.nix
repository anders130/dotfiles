{
    description = "Typst development environment";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        typix = {
            url = "github:loqusion/typix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        flake-parts.url = "github:hercules-ci/flake-parts";
    };

    outputs = inputs:
        inputs.flake-parts.lib.mkFlake {inherit inputs;} {
            systems = ["x86_64-linux"];
            perSystem = {
                system,
                pkgs,
                ...
            }: let
                typixLib = inputs.typix.lib.${system};
                src = typixLib.cleanTypstSource ./.;
                args = {
                    typstSource = "main.typ";
                    fontPaths = ["${pkgs.inter}/share/fonts/truetype"];
                };
                unstable_typstPackages = [
                    # packages from https://typst.app/universe/
                ];
                build-drv = typixLib.buildTypstProject (args // {inherit src unstable_typstPackages;});
                build-script = typixLib.buildTypstProjectLocal (args // {inherit src unstable_typstPackages;});
                typst-watch = typixLib.watchTypstProject args // {inherit unstable_typstPackages;};
                watchPDF = pkgs.writeShellApplication {
                    name = "watch";
                    runtimeInputs = [
                        typst-watch
                        pkgs.zathura
                    ];
                    text = ''
                        #!/usr/bin/env bash
                        set -euo pipefail

                        PDF="main.pdf"

                        cleanup() {
                            if [[ -n $WATCH_PID ]]; then
                                echo "Stopping typst-watch..."
                                pkill -P "$WATCH_PID" 2>/dev/null || true
                                kill "$WATCH_PID" 2>/dev/null || true
                            fi
                        }
                        trap cleanup EXIT

                        typst-watch &
                        WATCH_PID=$!

                        while [ ! -f "$PDF" ]; do sleep 0.1; done
                        zathura "$PDF" >/dev/null 2>&1
                        wait "$WATCH_PID"
                    '';
                };
            in {
                checks = {
                    inherit build-drv build-script typst-watch;
                };
                packages.default = build-drv;
                apps = rec {
                    default = watch;
                    watch.program = watchPDF;
                    build.program = build-script;
                };
            };
        };
}
