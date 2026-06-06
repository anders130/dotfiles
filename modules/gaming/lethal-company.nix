{
    dots.gaming.provides.lethal-company.homeManager = {pkgs, ...}: {
        home.packages = [
            pkgs.r2modman
            (pkgs.writeShellApplication {
                name = "lethal-loader";
                runtimeInputs = with pkgs; [unzip coreutils];
                text = ''
                    if [ "$#" -lt 2 ]; then
                        echo "Usage: lethal-loader <source-folder> <profile-name>"
                        exit 1
                    fi

                    src=$1
                    profile=$2
                    destination="$HOME/.config/r2modmanPlus-local/LethalCompany/profiles/$profile/BepInEx/plugins"

                    echo "Using source: $src"
                    echo "Using profile: $profile"
                    echo "Destination: $destination"

                    mkdir -p "$destination"

                    move_zip_overwrite() {
                        local zipfile=$1 target=$2
                        if [ ! -f "$zipfile" ]; then
                            echo "⚠️ $zipfile not found"
                            return
                        fi
                        local tmpdir
                        tmpdir=$(mktemp -d)
                        unzip -o "$zipfile" -d "$tmpdir"
                        for item in "$tmpdir"/*; do
                            local name
                            name=$(basename "$item")
                            rm -rf "''${target:?}/$name"
                            mv "$item" "$target/"
                        done
                        rm -rf "$tmpdir"
                    }

                    move_zip_overwrite "$src/CustomMods.zip" "$destination"
                    move_zip_overwrite "$src/CustomSongs.zip" "$destination"

                    mkdir -p "$destination/CustomSounds"
                    move_zip_overwrite "$src/CustomSounds.zip" "$destination/CustomSounds"

                    echo "✅ Done!"
                '';
            })
        ];
    };
}
