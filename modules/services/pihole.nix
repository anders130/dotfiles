args @ {
    config,
    inputs,
    ...
}: let
    inherit (builtins) removeAttrs;

    webPort = 168;
    pruneModule = path: let
        orig = import path args;
    in
        orig // {meta = removeAttrs (orig.meta or {}) ["doc"];};

    ftlModule = "${inputs.nixpkgs-unstable}/nixos/modules/services/networking/pihole-ftl.nix";
    webModule = "${inputs.nixpkgs-unstable}/nixos/modules/services/web-apps/pihole-web.nix";
in {
    imports = [
        (pruneModule ftlModule)
        (pruneModule webModule)
    ];
    services = {
        pihole-ftl = {
            enable = true;
            openFirewallDNS = true;
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
