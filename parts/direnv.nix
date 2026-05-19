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
    flake.modules.homeManager.direnv = {
        programs.direnv = {
            enable = true;
            silent = true;
            nix-direnv.enable = true;
            config.global.warn_timeout = 0;
        };
    };
}
