{pkgs, ...}: {
    stylix.targets.plymouth.enable = false;
    boot = {
        plymouth = {
            enable = true;
            theme = "flame";
            themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = ["flame"];})];
        };
        # Enable "Silent boot"
        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
            "quiet"
            "boot.shell_on_fail"
            "udev.log_priority=3"
            "rd.systemd.show_status=auto"
        ];
        # Hide the OS choice for bootloaders.
        # It's still possible to open the bootloader list by pressing any key
        # It will just not appear on screen unless a key is pressed
        loader.timeout = 0;
    };
}
