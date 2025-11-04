{pkgs, ...}: {
    modules.services.minecraft.servers.cobblemon-1-21-1 = {
        version = "1.21.1";
        type = "fabric";
        onlyFriends = true;
        rcon.enable = true;
        mods = ./_mods.nix;
        modpack = pkgs.fetchzip {
            url = "https://mediafilez.forgecdn.net/files/6132/445/Server%20Files%20-%20Cobblemon%20Modpack%20%5BFabric%5D%201.6.1.zip";
            sha512 = "sha512-vVXD/2zToZImJk1SLdtedOnbaOtt6QlGP6MA+4+gncXpVK+BSma6vdnG9oh/JJKcJoTps3BGxccGg6aYqPllmQ==";
            stripRoot = false;
        };
        ignoredMods = ["fabric-api-0.115.0+1.21.1.jar"];
        ram = "8G";
        serverProperties.enable-command-block = true;
    };
}
