{
    den,
    inputs,
    ...
}: {
    flake-file.inputs.project.url = "github:anders130/project";

    flake.wrappers.tmux = {lib, ...}: {
        configAfter = lib.mkAfter ''
            bind o display-popup -E -w 60% -h 70% -b rounded -S "fg=#8aadf4" "project"
        '';
    };

    den.aspects.project = {
        includes = [den.aspects.tmux];
        homeManager = {config, ...}: {
            imports = [inputs.project.homeManagerModules.default];
            programs.project = {
                enable = true;
                palette = with config.lib.stylix.colors.withHashtag; [
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
            };
        };
    };
}
