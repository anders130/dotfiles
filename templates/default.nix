{
    default = {
        path = ./default;
        description = "default flake template";
        welcomeText = ''
            Use this template as a starting point for your own flakes.
        '';
    };

    dev = {
        description = "dev environment templates";
        simple = {
            path = ./dev/simple;
            description = "simple dev environment with no pre-installed packages";
            welcomeText = ''
                This template is a basic dev environment with no pre-installed packages.
                Add your own packages to the devShells.default package list.
            '';
        };
    };
}
