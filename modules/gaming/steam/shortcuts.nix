{
    perSystem = {pkgs, ...}: {
        packages.regen-steam-shortcuts = pkgs.writeShellApplication {
            name = "regen-steam-shortcuts";
            runtimeInputs = with pkgs; [coreutils gnugrep desktop-file-utils];
            text = ''
                usage() {
                    cat <<'EOF'
                regen-steam-shortcuts - rebuild Steam game .desktop shortcuts

                USAGE:
                    regen-steam-shortcuts [OPTIONS]

                OPTIONS:
                    -o, --output DIR       Where to write .desktop files
                                           (default: ~/.local/share/applications)
                    -r, --steam-root DIR   Steam install/config root holding
                                           steamapps/libraryfolders.vdf. May be repeated
                                           or comma-separated. Default: autodetect standard
                                           and flatpak locations.
                    -f, --force            Also write shortcuts for games Steam already has
                                           a (differently named) .desktop for. Default: skip
                                           those to avoid duplicates.
                    -n, --dry-run          Print what would be written, create nothing.
                    -h, --help             Show this help.

                Each run first removes shortcuts written by a previous run
                (steam_app_<appid>.desktop) for a clean slate, then regenerates.

                EXAMPLES:
                    regen-steam-shortcuts
                    regen-steam-shortcuts -o ~/Desktop
                    regen-steam-shortcuts -r /mnt/games/Steam --dry-run
                EOF
                }

                OUT="$HOME/.local/share/applications"
                DRY=0
                FORCE=0
                ROOTS=()

                while [ $# -gt 0 ]; do
                    case "$1" in
                        -o|--output)     OUT="$2"; shift 2 ;;
                        -r|--steam-root) IFS=',' read -ra parts <<< "$2"; ROOTS+=("''${parts[@]}"); shift 2 ;;
                        -n|--dry-run)    DRY=1; shift ;;
                        -f|--force)      FORCE=1; shift ;;
                        -h|--help)       usage; exit 0 ;;
                        *)               echo "unknown arg: $1" >&2; usage >&2; exit 2 ;;
                    esac
                done

                if [ "''${#ROOTS[@]}" -eq 0 ]; then
                    ROOTS=(
                        "$HOME/.local/share/Steam"
                        "$HOME/.steam/steam"
                        "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam"
                    )
                fi

                STEAM_ROOT=""
                for root in "''${ROOTS[@]}"; do
                    [ -d "$root" ] && STEAM_ROOT="$root" && break
                done
                : "''${STEAM_ROOT:?Steam root not found (pass one with --steam-root)}"

                VDF="$STEAM_ROOT/steamapps/libraryfolders.vdf"
                [ -f "$VDF" ] || { echo "no libraryfolders.vdf at $VDF" >&2; exit 1; }

                [ "$DRY" -eq 1 ] || mkdir -p "$OUT"
                count=0
                skipped=0

                for old in "$OUT"/steam_app_*.desktop; do
                    [ -e "$old" ] || continue
                    [ "$DRY" -eq 1 ] || rm -f "$old"
                done

                while IFS= read -r libpath; do
                    apps="$libpath/steamapps"
                    [ -d "$apps" ] || continue
                    for acf in "$apps"/appmanifest_*.acf; do
                        [ -e "$acf" ] || continue
                        appid=$(grep -oP '"appid"\s+"\K[0-9]+' "$acf")
                        name=$(grep -oP '"name"\s+"\K[^"]+' "$acf")
                        [ -n "$appid" ] && [ -n "$name" ] || continue
                        case "$name" in
                            "Proton"*|"Steam Linux Runtime"*|"Steamworks Common Redistributables"*|*"BattlEye Runtime"*|*"EAC Runtime"*)
                                skipped=$((skipped + 1)); continue ;;
                        esac
                        if [ "$FORCE" -eq 0 ]; then
                            existing=$(grep -lE "steam://rungameid/$appid([^0-9]|\$)" "$OUT"/*.desktop 2>/dev/null \
                                | grep -v "/steam_app_$appid.desktop\$" || true)
                            if [ -n "$existing" ]; then
                                skipped=$((skipped + 1))
                                continue
                            fi
                        fi
                        if [ "$DRY" -eq 0 ]; then
                            cat > "$OUT/steam_app_$appid.desktop" <<EOF
                [Desktop Entry]
                Name=$name
                Comment=Play this game on Steam
                Exec=steam steam://rungameid/$appid
                Icon=steam_icon_$appid
                Terminal=false
                Type=Application
                Categories=Game;
                EOF
                        fi
                        count=$((count + 1))
                    done
                done < <(grep -oP '"path"\s+"\K[^"]+' "$VDF")

                if [ "$DRY" -eq 1 ]; then
                    echo "dry-run: $count new, $skipped skipped"
                    exit 0
                fi

                update-desktop-database "$OUT" 2>/dev/null || true
                echo "$count new, $skipped skipped -> $OUT"
            '';
        };
    };
}
