{
    pkgs,
    config,
    lib,
    ...
}: let
    inherit (lib) mkOption types;
    rconHost = "127.0.0.1";
    rconPassFile = config.sops.secrets.minecraft.path;

    backupScript = backupDir:
        pkgs.writeShellApplication {
            name = "minecraft-backup";
            runtimeInputs = with pkgs; [
                mcrcon
                gawk
                rsync
            ];
            text = ''
                set -euo pipefail

                RCON_CMD="mcrcon -H ${rconHost} -p $RCON_PASS"

                mkdir -p "${backupDir}"
                timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

                echo "Detecting running Minecraft servers..."
                for svc in $(systemctl list-units --state=running --plain --no-legend 'minecraft-server-*' | awk '{print $1}'); do
                    name=''${svc#"minecraft-server-"}
                    name=''${name%".service"}
                    worldDir="/srv/minecraft/$name/world"

                    if [ -d "$worldDir" ]; then
                        echo "Backing up $name..."
                        portFile="/srv/minecraft/$name/server.properties"
                        rconPort=$(grep '^rcon-port=' "$portFile" | cut -d= -f2 || true)
                        [ -z "$rconPort" ] && rconPort=25575

                        $RCON_CMD -P "$rconPort" "say Backup starting..."
                        $RCON_CMD -P "$rconPort" "save-off"
                        $RCON_CMD -P "$rconPort" "save-all flush"

                        dest="${backupDir}/''${name}_''${timestamp}"
                        mkdir -p "$dest"

                        rsync -a --delete "$worldDir/" "$dest/world/"

                        $RCON_CMD -P "$rconPort" "save-on"
                        $RCON_CMD -P "$rconPort" "say Backup completed successfully!"
                    else
                        echo "No world directory found for $name, skipping."
                    fi
                done
            '';
        };
in {
    options.backupDir = mkOption {
        type = types.str;
        default = "/srv/minecraft/backups";
        description = "Directory to store backups in";
    };
    config = cfg: {
        systemd = {
            services.minecraft-backup = {
                description = "Minecraft world backups for all running servers";
                serviceConfig = {
                    Type = "oneshot";
                    User = "minecraft";
                    Group = "minecraft";
                    ExecStart = "${backupScript cfg.backupDir}/bin/minecraft-backup";
                    EnvironmentFile = rconPassFile;
                };
            };
            timers.minecraft-backup = {
                description = "Timer for periodic Minecraft backups";
                wantedBy = ["timers.target"];
                timerConfig = {
                    OnCalendar = "daily";
                    Persistent = true;
                };
            };
            tmpfiles.rules = [
                "d ${cfg.backupDir} 0755 minecraft minecraft - -"
            ];
        };
    };
}
