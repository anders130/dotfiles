{dots, ...}: {
    den.aspects.theming = {
        includes = [dots.desktop.provides.hidden-apps];
        nixos = {
            stylix.targets.qt.enable = true;
            # hyprland-share-picker (Qt6) crashes if Kvantum loads via qt6ct's platform-theme
            # style hook (self-recursive base-style resolution). Apply Kvantum via QT_STYLE_OVERRIDE
            # directly instead, with gtk3 as the platform theme just to supply a dark-mode hint.
            systemd.user.services.xdg-desktop-portal-hyprland.serviceConfig = {
                UnsetEnvironment = ["QT_QPA_PLATFORMTHEME_QT6"];
                Environment = ["QT_QPA_PLATFORMTHEME=gtk3" "QT_STYLE_OVERRIDE=kvantum"];
            };
        };
        homeManager = {
            config,
            lib,
            ...
        }: let
            inherit (config.lib.stylix) colors;
            kvconfig = "${config.xdg.configHome}/Kvantum/Base16Kvantum/Base16Kvantum.kvconfig";
        in {
            stylix.targets = {
                qt.enable = true;
                kde.enable = false;
            };
            my.desktop.hiddenApps = ["kvantummanager" "qt5ct" "qt6ct"];
            # kvantumBlueAccent mutates this file in place every activation, so it always
            # differs from the store version; force avoids a backup collision on every switch.
            xdg.configFile."Kvantum".force = true;
            home.activation.kvantumBlueAccent = lib.hm.dag.entryAfter ["writeBoundary"] ''
                run sed -i 's/${colors.base0E-hex}/${colors.base0D-hex}/g' ${lib.escapeShellArg kvconfig}
            '';
        };
    };
}
