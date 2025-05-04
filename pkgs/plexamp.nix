{
    stdenv,
    fetchurl,
    nodejs_20,
    makeWrapper,
    lib,
}:
stdenv.mkDerivation rec {
    pname = "plexamp";
    version = "4.12.2";

    src = fetchurl {
        url = "https://plexamp.plex.tv/headless/Plexamp-Linux-headless-v${version}.tar.bz2";
        sha256 = "sha256-1hJtGj0ucIePmDmqpboZ7Gx9a/bMz9d8IHuOC4ZCRbo=";
    };

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
        mkdir -p $out/plexamp
        tar -xf $src -C $out/plexamp --strip-components=1

        makeWrapper ${nodejs_20}/bin/node $out/bin/plexamp \
            --add-flags "$out/plexamp/js/index.js"
    '';
}
