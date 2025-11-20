{
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mapAttrsToList mkMerge;

    mkNotifyService = cfg: serverName: serverCfg: let
        ntfyUrl = config.services.ntfy-sh.settings.base-url;
        logFile = "${cfg.dataDir}/${serverName}/logs/latest.log";
        messageCommand = message: "curl -u \"minecraft:$NTFY_PASS\" -d \"${message}\" ${ntfyUrl}/minecraft";

        script = pkgs.writeShellApplication {
            name = "minecraft-join-notify-${serverName}";
            runtimeInputs = with pkgs; [
                curl
                coreutils
            ];
            text = ''
                tail -n0 -F "${logFile}" | while IFS= read -r line; do
                  if echo "$line" | grep -q "joined the game"; then
                    player=$(echo "$line" | sed -E 's/.*: (.*) joined the game/\1/')
                    ${messageCommand "$player joined the ${serverName} server"}
                  fi

                  if echo "$line" | grep -q "left the game"; then
                    player=$(echo "$line" | sed -E 's/.*: (.*) left the game/\1/')
                    ${messageCommand "$player left the ${serverName} server"}
                  fi
                done
            '';
        };

        minecraftService = "minecraft-server-${serverName}.service";
    in {
        "minecraft-notify-${serverName}" = {
            description = "Join/leave notifications for Minecraft server ${serverName}";
            wantedBy = [minecraftService];
            after = [minecraftService];
            partOf = [minecraftService];
            serviceConfig = {
                User = "minecraft";
                Group = "minecraft";
                ExecStart = lib.getExe script;
                Restart = "on-failure";
                EnvironmentFile = config.sops.secrets.minecraft.path;
            };
        };
    };
in {
    config = cfg: {
        systemd.services = mkMerge (mapAttrsToList (mkNotifyService cfg) cfg.servers);
        services.ntfy-sh.settings = {
            auth-users = ["minecraft:$2b$10$S8Z4rWLrBfCdPhrJkfy/jeOOoDvHPozvf3TKnwRsRFg05kfAOFp4q:user"];
            auth-access = ["minecraft:minecraft:wo"];
        };
    };
}
