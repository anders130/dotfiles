{
    appimageTools,
    fetchurl,
}:
appimageTools.wrapType2 rec {
    name = "edex-ui";
    version = "2.2.8";
    src = fetchurl {
        url = "https://github.com/GitSquared/edex-ui/releases/download/v${version}/eDEX-UI-Linux-x86_64.AppImage";
        sha256 = "10fn0as77ikrpfpjxhs3lr0w8kg6ldn7a2wnq6h2q0ya47bqrwn8";
    };
}
