{
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mapAttrsToList mkMerge;
    mkMinecraftSource = cfg: serverName: serverCfg: let
        name = "minecraft-${serverName}";
        service = "minecraft-server-${serverName}.service";
    in {
        "${name}" = {
            target = "minecraft";
            user = "minecraft";
            group = "minecraft";
            wantedBy = [service];
            after = [service];
            partOf = [service];
            script = runtimeInputs:
                pkgs.writeShellApplication {
                    inherit runtimeInputs;
                    name = "notify-${name}";
                    text = ''
                        logFile="${cfg.dataDir}/${serverName}/logs/latest.log"

                        tail -n0 -F "$logFile" | while IFS= read -r line; do
                            if echo "$line" | grep -q "joined the game"; then
                                player=$(echo "$line" | sed -E 's/.*: (.*) joined the game/\1/')
                                message "$player joined the ${serverName} server"
                            fi

                            if echo "$line" | grep -q "left the game"; then
                                player=$(echo "$line" | sed -E 's/.*: (.*) left the game/\1/')
                                message "$player left the ${serverName} server"
                            fi
                        done
                    '';
                };
        };
    };
in {
    config = cfg: {
        modules.services.ntfy = {
            targets.minecraft = {
                secretFile = config.sops.secrets.minecraft.path;
                authHash = "$2b$10$S8Z4rWLrBfCdPhrJkfy/jeOOoDvHPozvf3TKnwRsRFg05kfAOFp4q";
            };
            sources = mkMerge (mapAttrsToList (mkMinecraftSource cfg) cfg.servers);
        };
    };
}
