{pkgs, ...}: {
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        package = pkgs.unstable.steam;
    };

    environment.systemPackages = with pkgs.unstable; [
        prismlauncher # minecraft launcher
        jdk17
        jdk8
        protonup-qt # easy ge-proton setup for steam

        lutris
        (writeShellScriptBin "forceMouseToGame" /*bash*/''
            monitor=DP-1
            expect_y=0
            curr_y=$(hyprctl -j monitors | ${jq}/bin/jq '.[0].y')
            if [ $curr_y -ne $expect_y ]
            then
                hyprctl keyword monitor $monitor, 3440x1440@144, 0x''${expect_y}, 1
                echo "Everything is normal again"
            else
                expect_y=$(($expect_y + 1440))
                hyprctl keyword monitor $monitor, 3440x1440@144, 0x''${expect_y}, 1
                echo "Game is on top"
            fi
        '')
    ];
}
