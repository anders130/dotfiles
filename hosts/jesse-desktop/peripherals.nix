{
    den.aspects.jesse-desktop.nixos = {
        config,
        pkgs,
        ...
    }: {
        # mouse
        services.ratbagd.enable = true;
        environment.systemPackages = [pkgs.piper];
        # audio
        my.desktop.audio.devices = {
            "Headset" = {
                match = {
                    "device.api" = "alsa";
                    "device.name" = "alsa_card.usb-GeneralPlus_USB_Audio_Device-00";
                };
                profile = "analog-stereo";
            };
            "Speakers" = {
                match = {
                    "device.api" = "alsa";
                    "device.name" = "alsa_card.pci-0000_31_00.4";
                };
                profile = "output:analog-stereo";
            };
            "Webcam" = {
                match = {
                    "device.api" = "alsa";
                    "device.name" = "alsa_card.usb-Anker_PowerConf_C200_Anker_PowerConf_C200_ACNV9P1F20610234-02";
                };
                profile = "off";
            };
            "Monitor" = {
                match = {
                    "device.api" = "alsa";
                    "device.bus-path" = "pci-0000:2f:00.1";
                };
                profile = "off";
            };
        };
        # monitors
        my.desktop.monitors = {
            DP-3 = {
                resolution = "2560x1440";
                refreshRate = 180;
                position = "-2560x0";
            };
            DP-1 = {
                isMain = true;
                resolution = "3440x1440";
                refreshRate = 144;
                position = "0x0";
            };
            DP-2 = {
                resolution = "2560x1440";
                refreshRate = 180;
                position = "3440x0";
            };
        };
        hardware.i2c.enable = true; # for brightness ctrl
        users.groups.i2c.members = config.users.normalUsers;
    };
}
