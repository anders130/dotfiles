{
    coreutils,
    icoutils,
    stdenv,
    fetchurl,
    wine,
}:
stdenv.mkDerivation rec {
    name = "keil-uvision-c51-${version}";
    version = "9.61";

    src = fetchurl {
        url = "file:///tmp/keil-uvision-c51-9.61-preinstalled.tar.xz";
        sha256 = "1v8f0znk4g52577c5cllkgw02g8wac3dc6xb31gl1g68nzxfbnh3";
    };

    buildInputs = [icoutils];

    buildCommand = /*bash*/''
        mkdir -p "$out/bin"
        mkdir -p "$out/wine/drive_c/"
        mkdir -p "$out/share/applications"
        mkdir -p "$out/share/icons"

        cp ${./UV4.sh} "$out/bin/UV4"
        chmod +x "$out/bin/UV4"
        tar xvf "$src" -C "$out/wine/drive_c/"

        substituteInPlace "$out/bin/UV4" \
                --replace @wine@ ${wine} \
                --replace @coreutils@ ${coreutils} \
                --replace @out@ "$out"

        # Extract icon from UV4.exe
        wrestool -x --output="$out/share/icons" -t14 "$out/wine/drive_c/Keil_v5/UV4/UV4.exe"
        mv "$out/share/icons/UV4.exe_14_120.ico" "$out/share/icons/keil-icon.ico" || true

        cat > "$out/share/applications/keil-uvision.desktop" <<EOF
        [Desktop Entry]
        Name=Keil uVision
        Exec=$out/bin/UV4
        Icon=$out/share/icons/keil-icon.ico
        Type=Application
        Terminal=false
        Categories=Development;IDE
        EOF
    '';
}
