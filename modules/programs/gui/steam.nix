{pkgs, ...}: {
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        package = pkgs.steam.override {
            extraPkgs = pkgs: [pkgs.attr];
        };
        extraCompatPackages = with pkgs; [
            proton-ge-bin
            protontricks
        ];
    };
}
