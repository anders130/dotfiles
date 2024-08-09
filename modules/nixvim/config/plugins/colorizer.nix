{
    plugins.nvim-colorizer = {
        enable = true;
        fileTypes = [
            "*"
            {
                language = "html";
                names = false;
            }
            {
                language = "nix";
                names = false;
            }
        ];
    };
}
