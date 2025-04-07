{
    inputs,
    pkgs,
    ...
}: let
    port = 25566;
in {
    imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];

    services.minecraft-servers = {
        enable = true;
        eula = true;

        dataDir = "/srv/minecraft";

        servers.vanilla-1-20-4 = {
            enable = true;
            autoStart = false;
            package = pkgs.minecraftServers.vanilla-1_20_4;
            serverProperties.server-port = port;
        };
    };

    networking.firewall.allowedTCPPorts = [port];
}
