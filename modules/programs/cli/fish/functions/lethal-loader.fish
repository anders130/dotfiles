function lethal-loader
    if test (count $argv) -lt 2
        echo "Usage: lethal-loader <source-folder> <profile-name>"
        return 1
    end

    set source $argv[1]
    set profile $argv[2]
    set destination "$HOME/.config/r2modmanPlus-local/LethalCompany/profiles/$profile/BepInEx/plugins"

    echo "Using source: $source"
    echo "Using profile: $profile"
    echo "Destination: $destination"

    mkdir -p "$destination"

    function move_zip_overwrite
        set zipfile $argv[1]
        set target $argv[2]

        if test -f $zipfile
            set tmpdir (mktemp -d)
            unzip -o "$zipfile" -d "$tmpdir"
            # Remove all existing destination items
            for item in $tmpdir/*
                set name (basename $item)
                if test -e "$target/$name"
                    rm -rf "$target/$name"
                end
                mv "$item" "$target/"
            end
            rm -rf "$tmpdir"
        else
            echo "⚠️ $zipfile not found"
        end
    end

    move_zip_overwrite "$source/CustomMods.zip" "$destination"
    move_zip_overwrite "$source/CustomSongs.zip" "$destination"

    mkdir -p "$destination/CustomSounds"
    move_zip_overwrite "$source/CustomSounds.zip" "$destination/CustomSounds"

    echo "✅ Done!"
end
