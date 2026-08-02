{
    den.aspects.jesse-desktop.nixos = {
        pkgs,
        lib,
        ...
    }: let
        openrgb = lib.getExe' pkgs.openrgb-with-all-plugins "openrgb";
        color = "FF4000"; # orange
        black = "000000";
        setColor = pkgs.writeShellScript "rgb-static" ''
            ${openrgb} --noautoconnect --device 'ASUS TUF Radeon RX 9070 XT Gaming OC' --mode static --color ${color} || true
            ${openrgb} --noautoconnect --device 'ASUS ROG STRIX B850-E GAMING WIFI' --mode static --color ${color} || true
            ${openrgb} --noautoconnect --device 'Roccat Vulcan 120-Series Aimo' --mode direct --color ${black} || true
            ${openrgb} --noautoconnect --device 'G502 HERO Gaming Mouse' --mode direct --color ${color} || true
        '';
    in {
        services.udev.extraRules = ''
            ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="19af", TAG+="systemd", ENV{SYSTEMD_WANTS}+="rgb-static-color.service"
        '';
        systemd.services.rgb-static-color = {
            description = "Set motherboard + GPU RGB to a static color";
            serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStart = setColor;
            };
        };
    };
}
