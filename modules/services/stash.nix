{
    config,
    lib,
    username,
    ...
}: let
    folder = "/mnt/rackflix/appdata/.stash";
in {
    services.stash = {
        inherit username;
        enable = true;
        group = "users";
        mutableSettings = true;
        passwordFile = "${folder}/config/password";
        jwtSecretKeyFile = "${folder}/config/jwt";
        sessionStoreKeyFile = "${folder}/config/session";
        settings.stash = [
            {path = "${folder}/media";}
        ];
    };
    # Stash module is stupid and unconditionally sets this
    users.users.${username}.isSystemUser = lib.mkForce false;

    services.caddy.virtualHosts."http://stash.${config.networking.hostName}" = lib.mkReverseProxy {
        inherit (config.services.stash.settings) port;
    };
}
