{
    inputs,
    config,
    lib,
    pkgs,
    ...
}: {
    imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];

    options.modules.services.minecraft = {
        enable = lib.mkEnableOption "minecraft";
    };

    config = lib.mkIf config.modules.services.minecraft.enable {
        services.minecraft-servers = {
            enable = true;
            eula = true;

            dataDir = "/srv/minecraft";

            servers.vanilla-1-20-4 = {
                enable = true;
                package = pkgs.minecraftServers.vanilla-1_20_4;
            };
        };

        networking.firewall.allowedTCPPorts = [25565];
    };
}
