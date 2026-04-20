{
    pkgs,
    lib,
    ...
}: let
    settings = {
        global_desktopSettings_browserIntegrationEnabled = true;
        global_desktopSettings_trayEnabled = true;
        global_desktopSettings_closeToTray = true;
        global_desktopSettings_startToTray = true;
    };
in {
    environment.systemPackages = [pkgs.bitwarden-desktop];
    hm.wayland.windowManager.hyprland.settings.windowrule = [
        "no_screen_share true, match:class Bitwarden"
    ];
    hm.home.activation.setBitwardenSettings = lib.hm.dag.entryAfter ["writeBoundary"]
    #bash
    ''
        config_file="$HOME/.config/Bitwarden/data.json"

        if [[ ! -f "$config_file" ]]; then
            echo "Bitwarden config not found, skipping..."
        else
            tmp=$(mktemp)
            ${lib.getExe pkgs.jq} '. * ${builtins.toJSON settings}' "$config_file" > "$tmp" && mv "$tmp" "$config_file"
        fi
    '';
}
