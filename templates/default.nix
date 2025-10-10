{
    flake.templates = {
        default = {
            path = ./default;
            description = "default flake template";
            welcomeText = ''
                Use this template as a starting point for your own flakes.
            '';
        };

        python = {
            path = ./python;
            description = "python development template";
            welcomeText = ''
                This template is a minimal python development template, that uses pytest for testing and pyproject for the project structure.
            '';
        };

        simple = {
            path = ./simple;
            description = "simple dev environment with no pre-installed packages";
            welcomeText = ''
                This template is a basic dev environment with no pre-installed packages.
                Add your own packages to the devShells.default package list.
            '';
        };

        typst = {
            path = ./typst;
            description = "typst development template using typix";
            welcomeText = ''
                This template is a typst development environment using typix for getting started. For more information, have a look at the typix documentation.
            '';
        };
    };
}
