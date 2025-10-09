inputs: final: prev: let
    inherit (inputs.nixpkgs-unstable.legacyPackages.${prev.system}) teams-for-linux;
in {
    teams-for-linux = teams-for-linux.overrideAttrs (oldAttrs: let
        xdgOpenWrapper = final.writeShellScriptBin "xdg-open" ''
            exec firefox -P work "$@"
        '';
        teamsWrapper = final.writeShellScriptBin "teams-for-linux-with-browser" ''
            PATH=${xdgOpenWrapper}/bin:$PATH exec ${teams-for-linux}/bin/teams-for-linux "$@"
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
}
