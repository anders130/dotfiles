{
    den.aspects.teams = {
        nixos = {
            config,
            lib,
            ...
        }: {
            options.my.teams.browser = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Command teams opens links with.";
            };
            config.nixpkgs.overlays = lib.mkIf (config.my.teams.browser != null) [
                (final: prev: {
                    teams-for-linux = prev.teams-for-linux.overrideAttrs (oldAttrs: let
                        xdgOpenWrapper = final.writeShellScriptBin "xdg-open" ''
                            exec ${config.my.teams.browser} "$@"
                        '';
                        teamsWrapper = final.writeShellScriptBin "teams-for-linux-with-browser" ''
                            PATH=${xdgOpenWrapper}/bin:$PATH exec ${prev.teams-for-linux}/bin/teams-for-linux "$@"
                        '';
                    in {
                        desktopItems = [
                            (prev.makeDesktopItem {
                                name = "teams-for-linux";
                                exec = "${teamsWrapper}/bin/teams-for-linux-with-browser %U";
                                icon = "teams-for-linux";
                                comment = oldAttrs.meta.description;
                                desktopName = "Teams";
                                startupWMClass = "Teams";
                                categories = ["Network" "InstantMessaging" "Chat"];
                            })
                        ];
                    });
                })
            ];
        };
        homeManager = {pkgs, ...}: {
            home.packages = [pkgs.teams-for-linux];
        };
    };
}
