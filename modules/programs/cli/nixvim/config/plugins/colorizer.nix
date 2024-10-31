{
    plugins.nvim-colorizer = {
        enable = true;
        userDefaultOptions.names = false;
        fileTypes = [
            "*"
            {
                language = "css";
                names = true;
            }
        ];
    };
}
