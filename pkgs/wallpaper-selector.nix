{
    coreutils,
    imagemagick,
    libnotify,
    rofi-wayland,
    swww,
    writeShellScriptBin,
}:
writeShellScriptBin "wallpaper-selector" ''
    #!/usr/bin/env bash

    # Get the wallpaper directory as an argument (default to ~/Pictures/Wallpapers)
    WALLPAPER_DIR="$1"
    ROFI_THEME="$2"
    CACHE_DIR="$HOME/.cache/wallpaper-thumbnails"
    HYPR_WALLPAPER="$HOME/.config/hypr/wallpaper.png"

    # Ensure the directory exists
    if [ ! -d "$WALLPAPER_DIR" ]; then
        echo "Wallpaper directory not found: $WALLPAPER_DIR"
        exit 1
    fi

    # Create cache dir if it doesn't exist
    mkdir -p "$CACHE_DIR"

    # Function to create a thumbnail for the wallpaper
    create_thumbnail() {
        local img="$1"
        local thumb="$2"
        if [ ! -f "$thumb" ]; then
            ${imagemagick}/bin/magick "$img" -strip -thumbnail 500x500^ -gravity center -extent 500x500 "$thumb"
        fi
    }

    # Convert images in directory and save to cache dir
    for image in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp}; do
        if [ -f "$image" ]; then
            filename=$(basename "$image")
            thumbnail="$CACHE_DIR/$filename"
            create_thumbnail "$image" "$thumbnail"
        fi
    done

    # Select a wallpaper with rofi, showing the thumbnail
    wallpaper=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -exec basename {} \; | \
        while read -r filename; do
            thumbnail="$CACHE_DIR/$filename"
            echo -en "$filename\x00icon\x1f$thumbnail\n"
        done | \
        ${rofi-wayland}/bin/rofi -dmenu -theme "$ROFI_THEME" -i -p "Select Wallpaper")

    # If a wallpaper was selected, set it with swww
    if [ -n "$wallpaper" ]; then
        selected_wallpaper="$WALLPAPER_DIR/$wallpaper"
        ${swww}/bin/swww img "$WALLPAPER_DIR/$wallpaper" --transition-type grow --transition-duration 1

        if [[ "$selected_wallpaper" != *.png ]]; then
            echo "Converting $selected_wallpaper to png"
            ${imagemagick}/bin/magick "$selected_wallpaper" "$HYPR_WALLPAPER"
        else
            echo "Copying $selected_wallpaper to $HYPR_WALLPAPER"
            ${coreutils}/bin/cp "$selected_wallpaper" "$HYPR_WALLPAPER"
        fi
        ${libnotify}/bin/notify-send "Wallpaper changed" "$wallpaper"
    fi
''
