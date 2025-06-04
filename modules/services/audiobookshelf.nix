{
    config,
    lib,
    ...
}: let
    host = "127.0.0.1";
    port = 8090;
in {
    services.audiobookshelf = {
        inherit host port;
        enable = true;
    };
    services.caddy.virtualHosts."http://audiobookshelf.${config.networking.hostName}" = lib.mkReverseProxy {
        inherit port;
        extraConfig = ''
            encode gzip zstd
        '';
    };
}
