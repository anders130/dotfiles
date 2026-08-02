{den, ...}: {
    den.aspects.teams = {
        includes = [den.aspects.desktop-entries];
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
            config = lib.mkIf (config.my.teams.browser != null) {
                my.desktop-entries.teams-for-linux = {
                    package = "teams-for-linux";
                    name = "teams-for-linux";
                    exec = prev: let
                        xdgOpenWrapper = prev.writeShellScriptBin "xdg-open" ''
                            exec ${config.my.teams.browser} "$@"
                        '';
                        teamsWrapper = prev.writeShellScriptBin "teams-for-linux-with-browser" ''
                            PATH=${xdgOpenWrapper}/bin:$PATH exec ${prev.teams-for-linux}/bin/teams-for-linux "$@"
                        '';
                    in "${teamsWrapper}/bin/teams-for-linux-with-browser %U";
                    icon = "teams-for-linux";
                    comment = prev: prev.teams-for-linux.meta.description;
                    desktopName = "Teams";
                    startupWMClass = "Teams";
                    categories = ["Network" "InstantMessaging" "Chat"];
                };
            };
        };
        homeManager = {pkgs, ...}: {
            home.packages = [pkgs.teams-for-linux];
        };
    };
}
