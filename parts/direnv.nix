{lib, ...}: {
    gitignore = [
        ".direnv"
        ".env"
    ];
    perSystem.files.file.".envrc".text = lib.concatLines [
        "dotenv_if_exists"
        "use flake"
    ];
    flake.modules.homeManager.direnv = {
        programs.direnv = {
            enable = true;
            silent = true;
            nix-direnv.enable = true;
            config.global.warn_timeout = 0;
        };
    };
}
