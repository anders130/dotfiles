{config, ...}: let
    inherit (config.networking) domain;
    tikaPort = "33001";
    gotenbergPort = "33002";
in {
    services.paperless = {
        enable = true;
        settings = {
            PAPERLESS_OCR_LANGUAGE = "deu+eng";

            PAPERLESS_TIKA_ENABLED = true;
            PAPERLESS_TIKA_ENDPOINT = "http://127.0.0.1:${tikaPort}";
            PAPERLESS_TIKA_GOTENBERG_ENDPOINT = "http://127.0.0.1:${gotenbergPort}";
        };
    };

    services.caddy.virtualHosts."paperless.${domain}:80".extraConfig = ''
        tls internal
        reverse_proxy http://localhost:28981 {
            header_down Referer-Policy "strict-origin-when-cross-origin"
        }
    '';

    virtualisation.oci-containers.containers = {
        gotenberg = {
            user = "gotenberg:gotenberg";
            image = "docker.io/gotenberg/gotenberg:8.12.0";
            cmd = ["gotenberg" "--chromium-disable-javascript=true" "--chromium-allow-list=file:///tmp/.*"];
            ports = ["127.0.0.1:${gotenbergPort}:3000"];
        };
        tika = {
            image = "docker.io/apache/tika:3.0.0.0";
            ports = ["127.0.0.1:${tikaPort}:9998"];
        };
    };
}
