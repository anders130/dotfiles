{
    den.aspects.nix.homeManager = {
        config,
        lib,
        pkgs,
        ...
    }: let
        nixWrapper = pkgs.writeShellApplication {
            name = "nix-wrapper";
            runtimeInputs = with pkgs; [nh nix-output-monitor];
            text = ''
                unfree=0
                args=()
                for arg in "$@"; do
                    if [ "$arg" = "--unfree" ]; then
                        unfree=1
                    else
                        args+=("$arg")
                    fi
                done

                if [ "$unfree" -eq 1 ]; then
                    NIXPKGS_ALLOW_UNFREE=1 nix "''${args[@]}" --impure
                else
                    case "''${args[0]:-}" in
                        build | shell | develop) nom "''${args[@]}" ;;
                        search) nh "''${args[@]}" ;;
                        *) nix "''${args[@]}" ;;
                    esac
                fi
            '';
        };
    in {
        programs.fish.interactiveShellInit = lib.optionalString config.programs.fish.enable ''
            function nix
                ${nixWrapper}/bin/nix-wrapper $argv
            end
        '';
    };
}
