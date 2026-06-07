{
    config,
    den,
    lib,
    ...
}: let
    inherit (config.flake.lib) style;
in {
    flake-file.inputs.project.url = "github:anders130/project";

    flake.wrappers.tmux = {pkgs, ...}: {
        configAfter = lib.mkAfter ''
            bind o display-popup -E -w 60% -h 70% -b rounded -S "fg=${(style.colors pkgs lib).withHashtag.base0D}" "project"
        '';
    };
    den.aspects.project = {
        includes = [den.aspects.tmux];
        homeManager = {
            inputs',
            pkgs,
            ...
        }: {
            home.packages = [
                (inputs'.project.packages.default.override {
                    palette = with (style.colors pkgs lib).withHashtag; [
                        base00
                        base08
                        base0B
                        base0A
                        base0D
                        base0E
                        base0C
                        base05
                        base03
                        base09
                        base01
                        base02
                        base0F
                        base06
                        base07
                        base04
                    ];
                })
            ];
        };
    };
}
