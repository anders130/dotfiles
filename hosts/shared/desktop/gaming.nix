{pkgs, ...}: {
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        package = pkgs.unstable.steam;
    };
}
