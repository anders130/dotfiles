{lib, ...}: {
    hm = {
        xdg.configFile."fastfetch/short.jsonc" = lib.mkSymlink ./short.jsonc;
        programs.fastfetch = {
            enable = true;
            settings = {
                logo = {
                    type = "kitty-icat";
                    preserveAspectRatio = true;
                    source = ./logo.png;
                };
                display = {
                    key.width = 8;
                    separator = "   ";
                    size.binaryPrefix = "si";
                };
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
                    {
                        format = "{/1}{-}{/}{/2}{-}{/}{} / {}";
                        key = " RAM";
                        keyColor = "blue";
                        type = "memory";
                    }
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
        };
    };
}
