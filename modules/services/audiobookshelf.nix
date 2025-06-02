{config, ...}: let
    host = "127.0.0.1";
    port = 8090;
in {
    services.audiobookshelf = {
        inherit host port;
        enable = true;
    };
    services.caddy.virtualHosts."http://audiobookshelf.${config.networking.hostName}".extraConfig = ''
        encode gzip zstd
        reverse_proxy http://${host}:${toString port}
    '';
}
