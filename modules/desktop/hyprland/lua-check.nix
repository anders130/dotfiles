{
    dots.desktop.provides.hyprland.nixos = {
        config,
        pkgs,
        lib,
        ...
    }: let
        inherit (lib) concatMap attrValues filterAttrs hasPrefix hasSuffix concatMapStringsSep escapeShellArg;

        isHyprLuaFile = name: _: hasPrefix "hypr/" name && hasSuffix ".lua" name;
        userLuaFiles = user: user.xdg.configFile |> filterAttrs isHyprLuaFile |> attrValues;
        luaConfigFiles = config.home-manager.users |> attrValues |> concatMap userLuaFiles;
        hyprlandLuaCheck = pkgs.runCommand "hyprland-lua-check" {nativeBuildInputs = [pkgs.lua5_4];} ''
            ${concatMapStringsSep "\n" (f: "luac -p ${escapeShellArg f.source}") luaConfigFiles}
            touch $out
        '';
    in {
        system.extraDependencies = [hyprlandLuaCheck];
    };
}
