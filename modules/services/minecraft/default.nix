{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkMerge;
    server-port = 25566;
    rcon-port = 25575;
in {
    imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];

    services.minecraft-servers = {
        enable = true;
        eula = true;

        dataDir = "/srv/minecraft";
        environmentFile = config.sops.secrets.minecraft.path;

        servers = let
            defaultServer = {
                enable = true;
                autoStart = false;
                serverProperties = {
                    inherit server-port;
                    motd = lib.mkDefault "This is a Minecraft Server";
                };
            };
            withRcon = {
                serverProperties = {
                    inherit rcon-port;
                    enable-rcon = true;
                    "rcon.password" = "@RCON_PASS@";
                    server-ip = "0.0.0.0";
                };
            };
            onlyFriends = {
                serverProperties = {
                    white-list = true;
                    enforce-whitelist = true;
                };
                whitelist = {
                    "anders130" = "c2e93d01-d0d9-4e19-95e3-85bf3020b4ef";
                    "PingPand" = "f3a1c150-11d7-453b-9f18-6173582c78ad";
                    "CorvPauer" = "4eeadfee-16c6-40c3-ad6c-661144cea4b4";
                    "Timfoxi" = "edececc7-205f-4804-942b-e7122bd1fb61";
                    "Freddyblitz" = "569ef34e-d78e-467e-b9af-c16ec4fa40bc";
                    "lego6cat" = "81948a2b-7475-4e77-ac14-de8d2c5a249a";
                    "Kotbaer" = "bc0a249e-b7d5-4fce-be3a-e59b889a7d99";
                };
            };
        in {
            vanilla-1-20-4 = mkMerge [
                defaultServer
                onlyFriends
                {
                    package = pkgs.minecraftServers.vanilla-1_20_4;
                }
            ];
            vanilla-1-21-5 = mkMerge [
                defaultServer
                onlyFriends
                withRcon
                {
                    package = pkgs.minecraftServers.vanilla-1_21_5;
                    serverProperties = {
                        gamemode = "survival";
                        motd = "NixOS Minecraft Server";
                    };
                }
            ];
        };
    };

    sops.secrets.minecraft = {
        sopsFile = ./secrets.env;
        format = "dotenv";
        owner = "minecraft";
        group = "minecraft";
    };

    networking.firewall.allowedTCPPorts = [
        server-port
        rcon-port
    ];
}
