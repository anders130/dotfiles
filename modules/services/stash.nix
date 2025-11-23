{
    config,
    username,
    ...
}: let
    folder = "/mnt/rackflix/appdata/.stash";
    mediaGroup = "media";
in {
    users = {
        groups.${mediaGroup} = {};
        users.${username}.extraGroups = [mediaGroup];
        users.stash.extraGroups = [mediaGroup];
    };
    services = {
        stash = {
            inherit username; # login name
            enable = true;
            mutableSettings = true;
            mutablePlugins = true;
            passwordFile = "${folder}/config/password";
            jwtSecretKeyFile = "${folder}/config/jwt";
            sessionStoreKeyFile = "${folder}/config/session";
            settings = {
                stash = [{path = "${folder}/media";}];
                plugins_path = "${folder}/plugins";
            };
        };
    };
    modules.services.caddy.virtualHosts."http://stash.${config.networking.hostName}" = {
        inherit (config.services.stash.settings) port;
        local = true;
    };
}
