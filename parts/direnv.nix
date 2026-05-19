{
    gitignore = [
        ".direnv"
        ".env"
    ];
    perSystem = {writeLines, ...}: {
        files.files = [
            {
                path = ".envrc";
                drv = writeLines ".envrc" [
                    "dotenv_if_exists"
                    "use flake"
                ];
            }
        ];
    };
}
