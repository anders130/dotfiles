{
    perSystem = {pkgs, ...}: let
        pyScript = pkgs.writeText "fetch-steam-icons.py"
        #py
        ''
            import os, sys, re, glob, struct, subprocess, tempfile, urllib.request

            CDN = "https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/apps"
            FORCE = "--force" in sys.argv


            def steam_root():
                for c in ["~/.local/share/Steam", "~/.steam/steam",
                          "~/.var/app/com.valvesoftware.Steam/.local/share/Steam"]:
                    p = os.path.expanduser(c)
                    if os.path.isdir(p):
                        return p
                sys.exit("Steam root not found")


            def installed(S):
                ids = set()
                vdf = os.path.join(S, "steamapps/libraryfolders.vdf")
                for lp in re.findall(r'"path"\s+"([^"]+)"', open(vdf, encoding="latin-1").read()):
                    for acf in glob.glob(os.path.join(lp, "steamapps", "appmanifest_*.acf")):
                        m = re.search(r'"appid"\s+"(\d+)"', open(acf, encoding="latin-1").read())
                        if m:
                            ids.add(int(m.group(1)))
                return ids


            def clienticons(S):
                d = open(os.path.join(S, "appcache/appinfo.vdf"), "rb").read()
                if struct.unpack_from("<I", d, 0)[0] != 0x07564429:
                    return {}
                sti = struct.unpack_from("<q", d, 8)[0]
                cnt = struct.unpack_from("<I", d, sti)[0]
                p, strings = sti + 4, []
                for _ in range(cnt):
                    e = d.index(b"\x00", p)
                    strings.append(d[p:e].decode("latin-1"))
                    p = e + 1
                if "clienticon" not in strings:
                    return {}
                ci, pos, ic = strings.index("clienticon"), 16, {}
                while pos + 8 <= len(d):
                    a = struct.unpack_from("<I", d, pos)[0]
                    if a == 0:
                        break
                    sz = struct.unpack_from("<I", d, pos + 4)[0]
                    blob, i = d[pos + 8:pos + 8 + sz], 0
                    while i < len(blob):
                        t = blob[i]
                        if t == 0x01 and i + 5 <= len(blob):
                            ki = struct.unpack_from("<I", blob, i + 1)[0]
                            e = blob.index(b"\x00", i + 5)
                            v = blob[i + 5:e]
                            if ki == ci and len(v) == 40:
                                ic[a] = v.decode()
                            i = e + 1
                        elif t == 0x02:
                            i += 9
                        elif t == 0x00:
                            i += 5
                        elif t == 0x08:
                            i += 1
                        else:
                            i += 1
                    pos += 8 + sz
                return ic


            def existing_pngs(a):
                return glob.glob(os.path.expanduser(
                    f"~/.local/share/icons/hicolor/*/apps/steam_icon_{a}.png"))


            def convert_largest(ico, png):
                frames = subprocess.run(["magick", "identify", "-format", "%p %w\n", ico],
                                        capture_output=True, text=True).stdout.split("\n")
                idx = max((f for f in frames if len(f.split()) == 2),
                          key=lambda f: int(f.split()[1])).split()[0]
                subprocess.run(["magick", f"{ico}[{idx}]", "-background", "none", png], check=True)


            def main():
                S = steam_root()
                ids, ic = installed(S), clienticons(S)
                dest = os.path.expanduser("~/.local/share/icons/hicolor/256x256/apps")
                os.makedirs(dest, exist_ok=True)
                done = miss = fail = skip = 0
                for a in sorted(ids):
                    h = ic.get(a)
                    if not h:
                        miss += 1
                        continue
                    if not FORCE and existing_pngs(a):
                        skip += 1
                        continue
                    try:
                        with tempfile.NamedTemporaryFile(suffix=".ico", delete=False) as f:
                            tmp = f.name
                        urllib.request.urlretrieve(f"{CDN}/{a}/{h}.ico", tmp)
                        for old in existing_pngs(a):
                            os.remove(old)
                        convert_largest(tmp, os.path.join(dest, f"steam_icon_{a}.png"))
                        os.unlink(tmp)
                        done += 1
                    except Exception:
                        fail += 1
                print(f"icons: {skip} cached, {done} fetched, {miss} no-hash, {fail} failed")
                subprocess.run(["gtk-update-icon-cache",
                                os.path.expanduser("~/.local/share/icons/hicolor")],
                               capture_output=True)


            if __name__ == "__main__":
                main()
        '';
    in {
        packages.regen-steam-shortcuts = pkgs.writeShellApplication {
            name = "regen-steam-shortcuts";
            runtimeInputs = with pkgs; [
                coreutils
                gnugrep
                desktop-file-utils
                python3
                imagemagick
                gtk3
            ];
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

                [ "$DRY" -eq 0 ] && python3 ${pyScript} || true

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
                            icon="steam_icon_$appid"
                            for png in "$HOME"/.local/share/icons/hicolor/*/apps/steam_icon_"$appid".png; do
                                [ -e "$png" ] && icon="$png" && break
                            done
                            cat > "$OUT/steam_app_$appid.desktop" <<EOF
                [Desktop Entry]
                Name=$name
                Comment=Play this game on Steam
                Exec=steam steam://rungameid/$appid
                Icon=$icon
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

        packages.fetch-steam-icons = pkgs.writeShellApplication {
            name = "fetch-steam-icons";
            runtimeInputs = with pkgs; [
                python3
                imagemagick
                gtk3
            ];
            text = "exec python3 ${pyScript} --force";
        };
    };
}
