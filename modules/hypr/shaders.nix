{
    lib,
    pkgs,
    ...
}: let
    switch-shaders = pkgs.writeShellScriptBin "switch-shaders" /*bash*/''
        set -e

        shaderPath=~/.config/hypr/shaders

        blank="blank.glsl"
        temperature="temperature.glsl"

        current="$(hyprctl getoption decoration:screen_shader -j | ${pkgs.gojq}/bin/gojq -r '.str')"

        if [[ "$current" =~ (blank|EMPTY) ]] || [[ "$current" == "" ]]; then
            hyprctl keyword decoration:screen_shader "$shaderPath/$temperature"
            echo set $temperature
        else
            hyprctl keyword decoration:screen_shader "$shaderPath/$blank"
            echo set $blank
        fi
    '';
in {
    environment.systemPackages = [switch-shaders];
    hm.xdg.configFile."hypr/shaders" = lib.mkSymlink ./shaders;
}
