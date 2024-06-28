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
    ];
}
