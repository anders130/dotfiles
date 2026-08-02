{
    flake-file.inputs.hyprsplit = {
        url = "github:shezdy/hyprsplit";
        inputs.hyprland.follows = "hyprland";
    };
    dots.desktop.provides.hyprland.homeManager = {
        config,
        inputs',
        lib,
        ...
    }: let
        inherit (lib) range concatMap nameValuePair listToAttrs readFile;
        inherit (lib.generators) toLua;
        inherit (config.lib.hyprland) mkDsp;
        hs = mkDsp "hs.dsp";
        hsConfig = {
            num_workspaces = 10;
            persistent_workspaces = false;
        };
    in {
        wayland.windowManager.hyprland.extraLuaFiles = {
            "hyprsplit/init" = {
                autoLoad = false;
                content = readFile "${inputs'.hyprsplit.packages.hyprsplitlua}/share/hyprsplit/init.lua";
            };
            "hyprsplit-config" = {
                autoLoad = true;
                content = ''
                    hs = require("hyprsplit")
                    hs.config(${toLua {} hsConfig})
                '';
            };
        };
        lib.hyprland = {
            inherit hs;
        };
        my.hyprland.binds =
            range 1 (hsConfig.num_workspaces - 1)
            |> concatMap (i: [
                (nameValuePair "SUPER + ${toString i}" (hs.focus {workspace = i;}))
                (nameValuePair "SUPER + SHIFT + ${toString i}" (hs.window.move {
                    workspace = i;
                    follow = false;
                }))
            ])
            |> listToAttrs;
    };
}
