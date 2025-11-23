{config, ...}: let
    host = "127.0.0.1";
    port = 8090;
in {
    services.audiobookshelf = {
        inherit host port;
        enable = true;
    };
    modules.services.caddy.virtualHosts."http://audiobookshelf.${config.networking.hostName}" = {
        inherit port;
        extraConfig = ''
            encode gzip zstd
        '';
        local = true;
    };
}
