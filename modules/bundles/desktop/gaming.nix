{
    config,
    lib,
    pkgs,
    ...
}: let
    forceMouseToGame = pkgs.writeShellScriptBin "forceMouseToGame" /*bash*/''
        monitor=DP-1 # TODO set the main monitor
        expect_y=0
        curr_y=$(hyprctl -j monitors | ${pkgs.jq}/bin/jq '.[0].y')
        if [ $curr_y -ne $expect_y ]
        then
            hyprctl keyword monitor $monitor, 3440x1440@144, 0x''${expect_y}, 1
            echo "Everything is normal again"
        else
            expect_y=$(($expect_y + 1440))
            hyprctl keyword monitor $monitor, 3440x1440@144, 0x''${expect_y}, 1
            echo "Game is on top"
        fi
    '';
in {
    config = lib.mkIf config.bundles.desktop.gaming.enable {
        programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            package = pkgs.unstable.steam.override {
                extraPkgs = pkgs: [pkgs.attr];
            };
        };

        environment.systemPackages =
            (lib.optionals config.modules.hypr.enable [
                forceMouseToGame
            ]) ++ (with pkgs.unstable; [
                protonup-qt # easy ge-proton setup for steam
                lutris

                # minecraft
                prismlauncher # minecraft launcher
                jdk17
                jdk8

                # other games
                space-cadet-pinball
                superTuxKart
            ]);
    };
}
