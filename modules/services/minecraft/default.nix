{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: let
    inherit (builtins) attrNames filter listToAttrs readDir;
    inherit (lib) genAttrs mkMerge;
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
                    "MelonDeity" = "606d2063-a2d8-462b-bd50-18d7b11d3cf1";
                    "Trockenbubi" = "d7359ca9-9f5c-4d7b-b322-568cbcb24d99";
                    "DocHoodson" = "6808996d-8e41-4aa2-a459-c4dcbfb0359d";
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
            vanilla-1_21_10 = mkMerge [
                defaultServer
                onlyFriends
                withRcon
                {
                    package = pkgs.minecraftServers.vanilla-1_21_10;
                    serverProperties = {
                        gamemode = "survival";
                        motd = "NixOS Minecraft Server";
                    };
                }
            ];
            cobblemon-1-21-1 = mkMerge [
                defaultServer
                onlyFriends
                withRcon
                (let
                    modpack = pkgs.fetchzip {
                        url = "https://mediafilez.forgecdn.net/files/6132/445/Server%20Files%20-%20Cobblemon%20Modpack%20%5BFabric%5D%201.6.1.zip";
                        sha512 = "sha512-vVXD/2zToZImJk1SLdtedOnbaOtt6QlGP6MA+4+gncXpVK+BSma6vdnG9oh/JJKcJoTps3BGxccGg6aYqPllmQ==";
                        stripRoot = false;
                    };
                    extraMods =
                        import ./_mods.nix pkgs
                        |> map (mod: {
                            name = "mods/${mod.name}";
                            value = mod;
                        })
                        |> listToAttrs;
                    baseMods =
                        "${modpack}/mods"
                        |> readDir
                        |> attrNames
                        |> filter (name: name != "fabric-api-0.115.0+1.21.1.jar")
                        |> map (name: {
                            name = "mods/${name}";
                            value = "${modpack}/mods/${name}";
                        })
                        |> listToAttrs;
                in {
                    package = pkgs.fabricServers.fabric-1_21_1;
                    serverProperties.enable-command-block = true;
                    jvmOpts = "-Xmx8G -Xms4G";
                    symlinks =
                        baseMods
                        // extraMods
                        // genAttrs [
                            "server-icon.png"
                        ] (name: "${modpack}/${name}");
                })
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
