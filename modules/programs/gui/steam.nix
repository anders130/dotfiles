{
    config,
    lib,
    pkgs,
    ...
}: {
    config = lib.mkIf config.modules.programs.gui.steam.enable {
        programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            package = pkgs.unstable.steam.override {
                extraPkgs = pkgs: [pkgs.attr];
            };
        };

        environment.systemPackages = [
            pkgs.protonup-qt
        ];
    };
}
