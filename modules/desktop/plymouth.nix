{
    den.aspects.desktop.nixos = {pkgs, ...}: {
        stylix.targets.plymouth.enable = false;
        nixpkgs.overlays = let
            overlay = _: prev: {
                adi1090x-plymouth-themes = prev.adi1090x-plymouth-themes.overrideAttrs (previousAttrs: {
                    installPhase =
                        previousAttrs.installPhase
                        + ''
                            find $out/share/plymouth/themes/ -name \*.script -exec sed -i 's/Window.GetX()/Window.GetX(0)/g' {} \;
                            find $out/share/plymouth/themes/ -name \*.script -exec sed -i 's/Window.GetY()/Window.GetY(0)/g' {} \;
                        '';
                });
            };
        in [overlay];
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
    };
}
