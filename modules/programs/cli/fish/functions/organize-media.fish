function organize-media
    # Parse command-line arguments
    argparse \
        's/source=' \
        'm/movies-dir=' \
        't/tv-shows-dir=' \
        'y/yes' \
        'h/help' \
        -- $argv
    or return

    # Show help message
    if set -q _flag_h
        set_color blue
        echo "Usage:"
        echo "  organize-media [OPTIONS]"
        echo
        set_color yellow
        echo "Options:"
        set_color normal
        printf "  %-25s %s\n" "-s, --source DIR"          "Directory to scan (default: ~/Downloads)"
        printf "  %-25s %s\n" "-m, --movies-dir DIR"      "Movies target dir (default: ~/Videos/Movies)"
        printf "  %-25s %s\n" "-t, --tv-shows-dir DIR"    "TV target dir (default: ~/Videos/TV)"
        printf "  %-25s %s\n" "-y, --yes"                 "Skip confirmation prompts"
        printf "  %-25s %s\n" "-h, --help"                "Show this help message"
        return 0
    end

    # Set default directories
    set source (set -q _flag_s; and echo $_flag_s[1]; or echo "$HOME/Downloads")
    set movies_dir (set -q _flag_m; and echo $_flag_m[1]; or echo "$HOME/Videos/Movies")
    set tv_shows_dir (set -q _flag_t; and echo $_flag_t[1]; or echo "$HOME/Videos/TV")
    set yes (set -q _flag_y; and echo 1; or echo 0)

    # Avoid duplicate destination names
    function unique_path -a path
        set dir (dirname "$path")
        set base (basename "$path")
        set name (string split -r -m1 . "$base")[1]
        set ext (string split -r -m1 . "$base")[2]
        test -z "$ext"; and set ext ""
        set i 1
        set new_path "$path"
        while test -e "$new_path"
            set suffix (test -z "$ext"; and echo " ($i)"; or echo " ($i).$ext")
            set new_path "$dir/$name$suffix"
            set i (math $i + 1)
        end
        echo "$new_path"
    end

    # Recursively merge directories
    function merge_dirs -a src_dir -a dest_dir
        mkdir -p "$dest_dir"
        for item in "$src_dir"/*
            set base_item (basename "$item")
            set dest_item "$dest_dir/$base_item"

            if test -d "$item" # it's a directory
                if test -d "$dest_item" # destination directory exists
                    merge_dirs "$item" "$dest_item" # recurse
                else
                    # move the whole directory if it doesn't exist in destination
                    mv "$item" "$dest_item"
                end
            else # it's a file
                if test -e "$dest_item" # destination file exists
                    set unique_dest_item (unique_path "$dest_item")
                    mv "$item" "$unique_dest_item"
                else
                    mv "$item" "$dest_item"
                end
            end
        end
        # remove the source directory after merging
        rmdir "$src_dir"
    end

    # Find movies and TV shows
    set movies
    set tv_shows
    for folder in "$source"/*
        for ext in mp4 mkv avi mov
            for movie in "$folder"/*.$ext
                if test -f "$movie"
                    set movies $movies "$movie"
                end
            end
        end

        for dir in "$folder"/*/
            if test -d "$dir"
                set tv_shows $tv_shows "$dir"
            end
        end
    end

    # Show summary
    set_color green
    echo "Organizing media..."
    set_color normal
    echo ""
    set_color blue
    echo "Source directory:      $source"
    echo "Movies directory:      $movies_dir"
    echo "TV shows directory:    $tv_shows_dir"
    set_color normal
    echo ""

    set_color magenta
    echo "Found (movies):   "(count $movies)
    echo "Found (TV shows): "(count $tv_shows)
    set_color normal
    echo ""

    # Process movies
    if test (count $movies) -gt 0
        set_color yellow
        echo "Processing Movies:"
        set_color normal
        for movie in $movies
            set filename (basename "$movie")
            set destination (unique_path "$movies_dir/$filename")

            if test "$destination" != "$movies_dir/$filename"
                set_color yellow --bold
                echo "⚠️  File exists, renaming to this file"
                set_color normal
            end

            if test "$yes" = "0"
                if not read_confirm "Move $movie → $destination?"
                    set_color red
                    echo "Skipping $movie"
                    set_color normal
                    echo ""
                    continue
                end
            end

            echo -n "Moving "; set_color cyan; echo "$movie"; set_color normal
            mkdir -p "$movies_dir"
            mv "$movie" "$destination"
            echo ""
        end
        echo ""
    end

    # Process TV shows
    if test (count $tv_shows) -gt 0
        set_color yellow
        echo "Processing TV Shows:"
        set_color normal
        for tv_show in $tv_shows
            set dirname (basename "$tv_show")
            set destination "$tv_shows_dir/$dirname"

            if test -d "$destination"
                # Destination exists, so we merge.
                if test "$yes" = "0"
                    if not read_confirm "Merge $tv_show → $destination?"
                        set_color red
                        echo "Skipping $tv_show"
                        set_color normal
                        echo ""
                        continue
                    end
                end

                echo -n "Merging "; set_color cyan; echo "$tv_show"; set_color normal; echo -n " into "; set_color cyan; echo "$destination"; set_color normal
                merge_dirs "$tv_show" "$destination"
                echo ""
            else
                # Destination does not exist, just move.
                if test "$yes" = "0"
                    if not read_confirm "Move $tv_show → $destination?"
                        set_color red
                        echo "Skipping $tv_show"
                        set_color normal
                        echo ""
                        continue
                    end
                end

                echo -n "Moving "; set_color cyan; echo "$tv_show"; set_color normal
                mkdir -p "$tv_shows_dir"
                mv "$tv_show" "$destination"
                echo ""
            end
        end
        echo ""
    end

    set_color green
    echo "Media organization complete ✅"
    set_color normal
    return 0
end
