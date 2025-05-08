{
    inputs,
    pkgs,
    ...
}: let
    server-port = 25566;
in {
    imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];

    services.minecraft-servers = {
        enable = true;
        eula = true;

        dataDir = "/srv/minecraft";

        servers = let
            defaultServer = {
                enable = true;
                autoStart = false;
                serverProperties = {
                    inherit server-port;
                };
            };
        in {
            vanilla-1-20-4 = defaultServer // {
                package = pkgs.minecraftServers.vanilla-1_20_4;
            };
            vanilla-1-21-5 = defaultServer // {
                package = pkgs.minecraftServers.vanilla-1_21_5;
                serverProperties = defaultServer.serverProperties // {
                    inherit server-port;
                    difficulty = "hard";
                    enforce-whitelist = true;
                    white-list = true;
                    gamemode = "survival";
                    motd = "NixOS Minecraft Server";
                };
                whitelist = {
                    "anders130" = "c2e93d01-d0d9-4e19-95e3-85bf3020b4ef";
                    "PingPand" = "f3a1c150-11d7-453b-9f18-6173582c78ad";
                    "CorvPauer" = "4eeadfee-16c6-40c3-ad6c-661144cea4b4";
                };
            };
        };
    };

    networking.firewall.allowedTCPPorts = [server-port];
}
