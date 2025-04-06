{
    config,
    lib,
    ...
}: {
    options = let
        inherit (lib) mkOption types;
        cfg = config.modules.services.tmodloader;
    in {
        port = mkOption {
            type = types.port;
            default = 7777;
        };
        dataDir = mkOption {
            type = types.str;
            default = "/var/lib/tModLoader";
        };
        tmodloaderVersion = mkOption {
            type = types.str;
            default = "latest";
            example = "v2025.02.3.0";
            description = "Version of tModLoader to use (https://github.com/tModLoader/tModLoader/releases)";
        };
        motd = mkOption {
            type = types.str;
            default = "Welcome to the server!";
        };
        shutdownMessage = mkOption {
            type = types.str;
            default = "Server is shutting down!";
        };
        mods = {
            enabled = mkOption {
                type = types.listOf types.int;
                default = [];
                description = "List of Steam Workshop ids to enable (https://steamcommunity.com/sharedfiles/filedetails/?id=<id>)";
            };
            download = mkOption {
                type = with types; listOf int;
                default = cfg.mods.enabled;
                description = ''
                    List of Steam Workstop ids to download
                    NOTE: This is only needed to cache a download
                '';
            };
            config = mkOption {
                type = with types; attrsOf attrs;
                default = {};
                example = {
                    NoFishingQuests_Config = {
                        useCustomCurrency = true;
                        goldMultiplier = "2.0";
                    };
                };
                description = ''
                    The mod configuration
                    These are turned into JSON files under `<data>/ModConfigs/<name>.json`
                '';
            };
        };
        maxPlayers = mkOption {
            type = types.int;
            default = 10;
            description = "Maximum amount of players allowed on the server";
        };
        world = {
            name = mkOption {
                type = types.str;
                default = "NixOS";
                description = "Name of the world";
            };
            seed = mkOption {
                type = types.str;
                default = "random";
                description = "Seed of the world";
            };
            size = mkOption {
                type = types.enum [
                    "small"
                    "medium"
                    "large"
                ];
                default = "large";
                description = "Size of the world";
            };
            difficulty = mkOption {
                type = types.enum [
                    "normal"
                    "expert"
                    "master"
                    "journey"
                ];
                default = "normal";
                description = "Difficulty of the world";
            };
        };
    };
    config = cfg: {
        virtualisation.oci-containers.containers.tmodloader = {
            image = "docker.io/jacobsmile/tmodloader1.4:${cfg.tmodloaderVersion}";
            autoStart = false;
            ports = ["7777:${toString cfg.port}"];
            volumes = [
                "/var/cache/tModLoader/workshop:/data/steamMods"
                "/var/cache/tModLoader/dotnet:/terraria-server/dotnet"
                "${cfg.dataDir}:/data/tModLoader/Worlds:rw"
                "/etc/tModLoader/ModConfigs:/data/tModLoader/ModConfigs"
            ];
            environmentFiles = [config.sops.secrets.tmodloader.path];
            environment = let
                mkMods = mods: lib.concatStringsSep "," (map toString mods);
            in {
                "TMOD_MOTD" = cfg.motd;
                "TMOD_SHUTDOWN_MESSAGE" = cfg.shutdownMessage;
                "TMOD_AUTODOWNLOAD" = mkMods cfg.mods.download;
                "TMOD_ENABLEDMODS" = mkMods cfg.mods.enabled;
                "TMOD_DIFFICULTY" =
                    {
                        "normal" = "0";
                        "expert" = "1";
                        "master" = "2";
                        "journey" = "3";
                    }
                    .${cfg.world.difficulty};
                "TMOD_WORLDNAME" = cfg.world.name;
                "TMOD_WORLDSEED" = cfg.world.seed;
                "TMOD_WORLDSIZE" =
                    {
                        "small" = "1";
                        "medium" = "2";
                        "large" = "3";
                    }
                    .${cfg.world.size};
                "TMOD_MAXPLAYERS" = toString cfg.maxPlayers;
            };
        };
        sops.secrets.tmodloader = {
            sopsFile = ./secrets.env;
            format = "dotenv";
        };
        networking.firewall.allowedTCPPorts = [cfg.port];
        systemd.tmpfiles.settings."50-tmodloader" = let
            d = {
                user = "root";
                group = "root";
                mode = "0755";
            };
        in {
            ${cfg.dataDir}.d = d;
            "/var/cache/tModLoader/workshop".d = d;
            "/var/cache/tModLoader/dotnet".d = d;
            "/etc/tModLoader/ModConfigs".d = d;
        };
        environment.etc = lib.mapAttrs' (name: value:
            lib.nameValuePair "tModLoader/ModConfigs/${name}.json" {
                text = builtins.toJSON value;
                mode = "0444";
            })
        cfg.mods.config;
    };
}
