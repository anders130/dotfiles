{lib, ...}: {
    gitignore = [
        ".direnv"
        ".env"
    ];
    perSystem.files.file.".envrc".text = lib.concatLines [
        "dotenv_if_exists"
        "use flake"
        "export NH_FLAKE=$PWD"
    ];
    den.aspects.direnv.homeManager = {
        config,
        lib,
        ...
    }: {
        programs.direnv = {
            enable = true;
            silent = true;
            nix-direnv.enable = true;
            config.global.warn_timeout = 0;
        };
        programs.fish.interactiveShellInit = lib.optionalString config.programs.fish.enable ''
            function __direnv_devshell_completions --on-event fish_prompt
                for p in $PATH
                    set -l dir (dirname $p)/share/fish/vendor_completions.d
                    if test -d $dir; and not contains $dir $fish_complete_path
                        set -g fish_complete_path $fish_complete_path $dir
                    end
                end
            end
        '';
    };
}
