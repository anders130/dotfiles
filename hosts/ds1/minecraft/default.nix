{
    modules.services.minecraft = {
        enable = true;
        backupDir = "/mnt/rackflix/appdata/minecraft/backups";
        friends = {
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
            "HuGei" = "af4f5eda-b15f-4f1e-b0af-d535e8fa2e2f";
            "F4tbro" = "08efa9e0-a999-4242-959f-dab3d57b28ec";
            "QueenKati1612" = "9cef4d25-6bd1-493d-baeb-91d1f5997ba4";
        };
        servers = {
            vanilla-1-20-4 = {
                enable = false;
                version = "1.20.4";
                type = "vanilla";
                onlyFriends = true;
            };
            vanilla-1-21-5 = {
                enable = false;
                version = "1.21.5";
                type = "vanilla";
                onlyFriends = true;
                rcon.enable = true;
                motd = "NixOS Minecraft Server";
                serverProperties.gamemode = "survival";
            };
        };
    };
}
