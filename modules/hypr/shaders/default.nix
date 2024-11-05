{
    config,
    lib,
    pkgs,
    username,
    ...
}: let
    cfg = config.modules.hypr;

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
    config = lib.mkIf cfg.enable {
        environment.systemPackages = [
            switch-shaders
        ];

        home-manager.users.${username} = {config, ...}: {
            xdg.configFile."hypr/shaders" = lib.mkSymlink config {
                source = ./.;
                recursive = true;
            };
        };
    };
}
