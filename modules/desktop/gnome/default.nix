{
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (lib.hm.gvariant) mkTuple;
    inherit (config.modules.utils.keyboard) layout variant;
in {
    services.xserver = {
        enable = true;
        displayManager.gdm.enable = lib.mkDefault true;
        desktopManager.gnome.enable = true;
    };
    services.gnome.core-utilities.enable = false;
    environment.gnome.excludePackages = [pkgs.gnome-tour];

    hm.dconf.settings = {
        "org/gnome/desktop/interface" = {
            clock-show-seconds = true;
            clock-show-weekday = true;
            enable-hot-corners = false;
            show-battery-percentage = true;
        };
        "org/gnome/shell".app-picker-layout = "[]"; # sort apps by name
        "org/gnome/mutter" = {
            edge-tiling = true;
            dynamic-workspaces = true;
            workspaces-only-on-primary = true;
        };
        "org/gnome/shell/app-switcher".current-workspace-only = false;
        # Fix gnome touchpad right click. See [this](https://git.gnome.org/browse/gsettings-desktop-schemas/commit/?id=77ff1d91d974b2aaebbf7d748f1cd904bc75330b)
        "org/gnome/desktop/peripherals/touchpad".click-method = "default";
        "org/gnome/desktop/input-sources".sources = [(mkTuple ["xkb" "${layout}+${variant}"])];

    };
}
