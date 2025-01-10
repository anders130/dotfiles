function rebuild -w nixos-rebuild
    # Default values
    set cmd switch
    set args
    set host

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
            case '*'
                set args $args $arg
        end
    end

    if test -n "$host"
        echo "Performing remote rebuild: $cmd with host: $host"
        eval "nixos-rebuild $cmd --flake $FLAKE\?submodules=1#$host $args --use-remote-sudo"
    else
        if test "x$NIX_FLAKE_DEFAULT_HOST" = "x"
            set_color red
            echo -n "error: "
            set_color normal
            echo '$NIX_FLAKE_DEFAULT_HOST is not set!'
            return
        end
        set host $NIX_FLAKE_DEFAULT_HOST

        sudo true # require password to do nothing
        if test $status -ne 0; return; end # exit if unsuccessful

        echo "Performing local rebuild: $cmd with host: $host"
        eval "nh os $cmd -H $host -- $args"
    end
end

complete -c rebuild --no-files
