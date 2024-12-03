{pkgs, ...}: {
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
        nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;
            open = false;
            nvidiaSettings = true;
            nvidiaPersistenced = true;
        };

        graphics = {
            enable = true;
            enable32Bit = true;
        };
    };

    environment.systemPackages = [
        (pkgs.writeScriptBin "set-fan-speed" ''${builtins.readFile ./set_fan_speed.sh}'')
    ];
}
