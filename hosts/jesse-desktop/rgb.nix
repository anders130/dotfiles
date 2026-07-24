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
            for attempt in 1 2 3 4 5 6; do
                if ${openrgb} --noautoconnect \
                    --device 'ASUS TUF Radeon RX 9070 XT Gaming OC' --mode static --color ${color} \
                    --device 'ASUS ROG STRIX B850-E GAMING WIFI' --mode static --color ${color} \
                    --device 'Roccat Vulcan 120-Series Aimo' --mode direct --color ${black} \
                    --device 'G502 HERO Gaming Mouse' --mode direct --color ${color}; then
                    exit 0
                fi
                sleep 3
            done
            exit 1
        '';
    in {
        systemd.services.rgb-static-color = {
            description = "Set motherboard + GPU RGB to a static color";
            wantedBy = ["multi-user.target"];
            after = ["systemd-udev-settle.service"];
            wants = ["systemd-udev-settle.service"];
            serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStart = setColor;
            };
        };
    };
}
