function update
    set -l major_version
    set -l hyprland_version

    # Parse arguments
    for i in (seq (count $argv))
        switch $argv[$i]
            case "--major"
                set major_version $argv[(math $i + 1)]
            case "--hyprland"
                set hyprland_version $argv[(math $i + 1)]
        end
    end

    # Update versions in flake.nix first
    if test -n "$major_version"
        set_color green
        echo "Updating nixpkgs, home-manager, and stylix to $major_version..."
        set_color white
        sed -i "s/nixpkgs\/nixos-[0-9]\+\.[0-9]\+/nixpkgs\/nixos-$major_version/g" flake.nix
        sed -i "s/github:nix-community\/home-manager?ref=release-[0-9]\+\.[0-9]\+/github:nix-community\/home-manager?ref=release-$major_version/g" flake.nix
        sed -i "s/github:danth\/stylix\/release-[0-9]\+\.[0-9]\+/github:danth\/stylix\/release-$major_version/g" flake.nix
    end

    if test -n "$hyprland_version"
        set_color green
        echo "Updating Hyprland and Hyprsplit to $hyprland_version..."
        set_color white
        sed -i 's/ref = ".*"/ref = "refs\/tags\/v'"$hyprland_version"'"/' flake.nix
        sed -i -E 's|(url = "github:shezdy/hyprsplit\?ref=)[^"]+(";)|\1v'"$hyprland_version"'\2|' flake.nix
    end

    nix flake update
    nix flake check --all-systems

    if read_confirm "Do you want to commit your changes?"
        git add flake.nix flake.lock
        git commit -m "update"
    end
    if read_confirm "Do you want to rebuild now?"
        rebuild boot
        if test $status != 0
            echo "Rebuild failed!"
            exit 1
        end
    end
    if read_confirm "Do you want to reboot now?"
        sudo reboot
    end

    set_color green
    echo "Update finished."
    set_color white
end

