{
    lib,
    nix,
    nh,
    nixos-rebuild,
    writeFishApplication,
    writers,
    rebuildArgs ? [],
}:
writeFishApplication {
    name = "rebuild";
    runtimeInputs = [
        nh
        nix
        (nixos-rebuild.override {inherit nix;})
    ];
    script = writers.writeFish "rebuild.fish" ''
        # Default values
        set cmd switch
        set args
        set host
        set rollback 0

        # Parse arguments
        set next_is_host 0
        for arg in $argv
            if test $next_is_host -eq 1
                set host $arg
                set next_is_host 0
                continue
            end

            switch $arg
                case switch boot test build dry-run
                    set cmd $arg
                case --host
                    set next_is_host 1
                case --rollback
                    set rollback 1
                case '*'
                    set args $args $arg
            end
        end

        if test -n "$host"
            echo "Performing remote rebuild: $cmd with host: $host"
            eval "nixos-rebuild $cmd --flake $NH_FLAKE\?submodules=1#$host $args --sudo"
        else
            if test "x$NIX_FLAKE_DEFAULT_HOST" = "x"
                set_color red
                echo -n "error: "
                set_color normal
                echo '$NIX_FLAKE_DEFAULT_HOST is not set!'
                return
            end
            set host $NIX_FLAKE_DEFAULT_HOST

            if test $rollback -eq 1
                echo "Performing rollback: $cmd with host: $host"
                eval "nh os rollback -d always"
                return
            end

            echo "Performing local rebuild: $cmd with host: $host"
            eval "nh os $cmd -H $host -d always -- $args ${builtins.concatStringsSep " " rebuildArgs}"
        end
    '';
    completions = writers.writeFish "rebuild.fish-completion-content" ''
        complete -c rebuild -w nixos-rebuild
        complete -c rebuild -s H -l host -r -d 'Host to deploy to'
        complete -c rebuild -l rollback -d 'Perform a rollback instead of a rebuild'
    '';
    meta = {
        description = "Wrapper script for nixos-rebuild with fish completions.";
        platforms = lib.platforms.all;
    };
}
