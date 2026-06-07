{inputs, ...}: let
    display = {
        key.width = 8;
        separator = "   ";
        size.binaryPrefix = "si";
    };
    ramModule = {
        format = "{/1}{-}{/}{/2}{-}{/}{} / {}";
        key = " RAM";
        keyColor = "blue";
        type = "memory";
    };
in {
    flake.wrappers.fastfetch = {
        pkgs,
        lib,
        ...
    }: {
        imports = [inputs.wrapper-modules.wrapperModules.fastfetch];
        settings = {
            logo = {
                type = "kitty-icat";
                preserveAspectRatio = true;
                source = ./logo.png;
            };
            inherit display;
            modules = [
                {
                    format = "{3}";
                    key = " OS";
                    keyColor = "green";
                    type = "os";
                }
                {
                    key = " VER";
                    keyColor = "yellow";
                    type = "kernel";
                }
                {
                    key = "󰅐 UP";
                    keyColor = "blue";
                    type = "uptime";
                }
                {
                    key = "󰏖 PKG";
                    keyColor = "magenta";
                    type = "packages";
                }
                "break"
                {
                    format = "{1} ({5})";
                    key = " CPU";
                    keyColor = "green";
                    type = "cpu";
                }
                {
                    format = "{name}";
                    key = " GPU";
                    keyColor = "yellow";
                    type = "gpu";
                }
                ramModule
                "break"
                {
                    compactType = "scaled";
                    key = "󰍹 RES";
                    keyColor = "cyan";
                    type = "display";
                }
                {
                    format = "{2}";
                    key = " WM";
                    keyColor = "green";
                    type = "wm";
                }
                {
                    format = "{pretty-name}";
                    key = " TER";
                    keyColor = "yellow";
                    type = "terminal";
                }
                {
                    format = "{pretty-name}";
                    key = "󰈺 SH";
                    keyColor = "blue";
                    type = "shell";
                }
                "break"
                {
                    symbol = "circle";
                    type = "colors";
                }
            ];
        };

        wrapperVariants.fastfetch-short = {
            exePath = "bin/fastfetch";
            flags."--config" = lib.mkForce (
                pkgs.writeText "fastfetch-short.json" (builtins.toJSON {
                    logo.type = "none";
                    inherit display;
                    modules = [
                        "title"
                        {
                            key = "󰅐 UP";
                            keyColor = "green";
                            type = "uptime";
                        }
                        ramModule
                    ];
                })
            );
        };
    };

    den.aspects.fastfetch.homeManager = {self', ...}: {
        home.packages = [self'.packages.fastfetch];
    };
}
