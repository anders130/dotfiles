{
    lib,
    pkgs,
    ...
}: let
    catpuccin-theme = pkgs.fetchzip {
        url = "https://github.com/PrismLauncher/Themes/releases/download/2025-03-04_1741083069/Catppuccin-Macchiato-theme.zip";
        sha256 = "sha256-8czrw6IuKh+Q6uUzNN4Gu3AaxaHsW2lHn3Vkt6B2eoo=";
    };
in {
    environment.systemPackages = with pkgs; [
        prismlauncher # minecraft launcher
    ];

    hm.home = {
        file.".local/share/PrismLauncher/themes/Catppuccin-Macchiato".source = "${catpuccin-theme}/Catppuccin-Macchiato";

        activation.setPrismLauncherTheme = lib.hm.dag.entryAfter ["writeBoundary"] /*bash*/''
            config_file="$HOME/.local/share/PrismLauncher/prismlauncher.cfg"

            # Ensure the config file exists
            mkdir -p "$(dirname "$config_file")"
            touch "$config_file"

            # Define key-value pairs to update
            declare -A settings=(
                ["ApplicationTheme"]="Catppuccin-Macchiato"
                ["BackgroundCat"]="teawie"
                ["IconTheme"]="pe_light"
            )

            # Loop through settings and update them
            for key in "''${!settings[@]}"; do
                value="''${settings[$key]}"
                if grep -q "^$key=" "$config_file"; then
                    sed -i "s|^$key=.*|$key=$value|" "$config_file"
                else
                    echo "$key=$value" >> "$config_file"
                fi
            done
        '';
    };
}
