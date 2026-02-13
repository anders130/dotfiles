{
    config,
    pkgs,
    ...
}: let
    logDir = "/var/lib/hytale/data/logs";
    hytaleService = "podman-hytale.service";
    user = "root";
    group = "root";
in {
    config = cfg: {
        sops.secrets.hytale = {
            inherit group;
            owner = user;
            sopsFile = ./secrets.env;
            format = "dotenv";
        };
        modules.services.ntfy = {
            targets.hytale = {
                secretFile = config.sops.secrets.hytale.path;
                authHash = "$2a$10$YgSwV9dZU.SxpQ0ODxHOVeeSwGYcrQ9W.iOjexBmCofs5kBDlC7Oi";
            };
            sources.hytale = {
                inherit user group;
                wantedBy = [hytaleService];
                after = [hytaleService];
                partOf = [hytaleService];
                script = runtimeInputs:
                    pkgs.writeShellApplication {
                        inherit runtimeInputs;
                        name = "notify-hytale";
                        text = ''
                            get_latest_log() {
                                find ${logDir} -maxdepth 1 -type f -name '*_server.log' -print \
                                | sort | tail -n1
                            }

                            follow_log() {
                                local logfile="$1"
                                declare -A online_players

                                while IFS= read -r line; do
                                    if echo "$line" | grep -q "Player '.*' joined world"; then
                                        player=$(echo "$line" | sed -nE "s/.*Player '([^']+)'.*/\1/p")
                                        if [ -z "''${online_players[$player]+x}" ]; then
                                            online_players["$player"]=1
                                            message "$player joined the Hytale server"
                                        fi
                                    fi
                                    if echo "$line" | grep -q "Removing player '"; then
                                        player=$(echo "$line" | sed -nE "s/.*Removing player '([^']+)'.*/\1/p")
                                        if [ -n "''${online_players[$player]+x}" ]; then
                                            unset "online_players[$player]"
                                            message "$player left the Hytale server"
                                        fi
                                    fi
                                done < <(tail -n0 -F "$logfile")
                            }

                            while true; do
                                logfile=$(get_latest_log)
                                [ -z "$logfile" ] && sleep 5 && continue
                                follow_log "$logfile"
                            done
                        '';
                    };
            };
        };
    };
}
