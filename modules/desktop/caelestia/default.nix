{dots, ...}: {
    flake-file.inputs = {
        caelestia-cli = {
            url = "github:caelestia-dots/cli";
            inputs = {
                caelestia-shell.follows = "caelestia-shell";
                nixpkgs.follows = "caelestia-shell/nixpkgs";
            };
        };
        caelestia-shell = {
            url = "github:caelestia-dots/shell";
            inputs.caelestia-cli.follows = "caelestia-cli";
        };
    };
    flake-follows.exclude = ["caelestia-shell.nixpkgs"];

    den.schema.host = {lib, ...}: let
        inherit (lib) mkEnableOption;
    in {
        options.caelestia = {
            showNetwork = mkEnableOption "show network status in caelestia bar";
            showAudio = mkEnableOption "show audio switcher in caelestia bar";
        };
    };

    dots.desktop.provides.caelestia = {host, ...}: {
        includes = [dots.desktop.provides.hyprland];
        homeManager = {osConfig, ...}: {
            my.caelestia.status = {
                showNetwork = host.caelestia.showNetwork or false;
                showAudio = host.caelestia.showAudio or false;
                showBluetooth = osConfig.hardware.bluetooth.enable;
                showBattery = osConfig.services.upower.enable && osConfig.services.power-profiles-daemon.enable;
            };
            # TODO: remove this once home-manager module supports this
            systemd.user.services.caelestia.Service.Environment = ["QT_QPA_PLATFORMTHEME=gtk3"];
        };
    };
}
