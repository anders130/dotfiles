{
    den,
    dots,
    ...
}: {
    den.aspects.teams = {
        includes = [den.aspects.desktop-entries dots.desktop.provides.window-rules];
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
            # the floating self-preview shown while screen sharing; teams-for-linux already
            # sizes it to match the shared content's aspect ratio, so just float it rather than
            # forcing a size. Title changes at runtime ("...Screen Share Preview" -> "...Screen
            # is being shared"), hence the prefix match; Hyprland's title match is a full
            # regex_match, so it needs the trailing ".*" or it won't match anything.
            my.desktop.windowRules.teams-screenshare-preview = {
                matchType = "title";
                match = "^Teams for Linux - .*";
                float = true;
            };
        };
    };
}
