{
    dots.desktop.provides.hyprland.homeManager = let
        mkDsp = ns: let
            call = fn: arg: {inherit ns fn arg;};
            call0 = fn: {inherit ns fn;};
        in {
            exec_cmd = call "exec_cmd";
            global = call "global";
            layout = call "layout";
            focus = call "focus";
            workspace.toggle_special = call "workspace.toggle_special";
            window = {
                close = call0 "window.close";
                float = call "window.float";
                fullscreen = call0 "window.fullscreen";
                pin = call0 "window.pin";
                move = call "window.move";
                drag = call0 "window.drag";
                resize = call "window.resize";
            };
        };
        hl = mkDsp "hl.dsp";
    in {
        lib.hyprland = {
            inherit hl mkDsp;
        };
    };
}
