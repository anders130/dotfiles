{
    config,
    inputs,
    lib,
    ...
}: let
    inherit (builtins) concatMap filter;
    inherit (lib) mapAttrsToList removePrefix;

    webPort = 168;
in {
    services = {
        pihole-ftl = {
            enable = true;
            openFirewallDNS = true;
            settings = {
                dns = {
                    upstreams = ["8.8.8.8" "8.8.4.4"];
                    hosts = let
                        extractUrls = config:
                            config.modules.services.caddy.virtualHosts
                            |> mapAttrsToList (name: value: {inherit name value;})
                            |> filter ({value, ...}: value.local)
                            |> map (
                                {name, ...}:
                                    name
                                    |> removePrefix "https://"
                                    |> removePrefix "http://"
                            );
                    in
                        inputs.self.nixosConfigurations
                        |> mapAttrsToList (_: value: value.config)
                        |> filter (config: config.modules.utils.networking.address != null)
                        |> concatMap (config: let
                            inherit (config.modules.utils.networking) address;
                            urls = extractUrls config;
                        in
                            map (url: "${address} ${url}") urls);
                    listeningMode = "LOCAL";
                };
                dhcp.active = false;
            };
        };
        pihole-web = {
            enable = true;
            ports = [webPort];
        };
    };
    modules.services.caddy.virtualHosts."http://pihole.${config.networking.hostName}" = {
        port = webPort;
        local = true;
    };
}
