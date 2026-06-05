{inputs, ...}: {
    flake-file.inputs.project.url = "github:anders130/project";
    den.aspects.project.homeManager = {config, ...}: {
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
}
