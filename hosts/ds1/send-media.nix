{
    lib,
    pkgs,
    ...
}: let
    incomingPath = "/home/admin/public";
in {
    environment.etc."media-mover/mappings.conf".text = let
        mappings = {
            "movies" = {
                path = "/mnt/rackflix/data/Videos/Movies";
                owner = "admin:users";
            };
            "series" = {
                path = "/mnt/rackflix/data/Videos/Serien";
                owner = "admin:users";
            };
            "stash" = {
                path = "/mnt/rackflix/appdata/.stash/media";
                owner = "admin:media";
            };
        };
    in
        mappings
        |> lib.mapAttrsToList (name: v: "${name}=${v.path}=${v.owner}")
        |> builtins.concatStringsSep "\n";

    systemd = {
        tmpfiles.rules = ["d ${incomingPath} 2775 admin users -"];

        services.media-mover = {
            description = "Move files from incoming drop folders to target paths";
            after = ["local-fs.target"];
            serviceConfig = {
                Type = "oneshot";
            };
            path = with pkgs; [
                coreutils
                findutils
                rsync
            ];
            script = ''
                INCOMING="${incomingPath}"
                MAP_FILE="/etc/media-mover/mappings.conf"

                log() {
                    echo "media-mover: $*"
                    ${pkgs.systemd}/bin/systemd-cat -t media-mover echo "$*"
                }

                if [ ! -f "$MAP_FILE" ]; then
                    log "mappings file missing: $MAP_FILE"
                    exit 1
                fi

                log "start incoming=$INCOMING"

                while IFS='=' read -r key dest owner || [ -n "$key" ]; do
                    if [ -z "$key" ] || [ "''${key#\#}" != "$key" ]; then
                        continue
                    fi

                    dest="$(echo "$dest" | tr -d '\r')"
                    owner="$(echo "$owner" | tr -d '\r')"
                    src="$INCOMING/$key"

                    if [ ! -d "$src" ]; then
                        log "skip $key: $src not found"
                        continue
                    fi

                    if [ -z "$(ls -A "$src" 2>/dev/null)" ]; then
                        continue
                    fi

                    if [ ! -d "$dest" ]; then
                        log "target missing: $dest (from $key)"
                        continue
                    fi

                    log "moving $src -> $dest"

                    rsync_args=(-a --remove-source-files --mkpath)
                    if [ -n "$owner" ]; then
                        rsync_args+=(--chown="$owner")
                    fi
                    rsync "''${rsync_args[@]}" "$src"/ "$dest"/

                    find "$src" -type d -empty -delete 2>/dev/null || true
                    log "done $key"
                done < "$MAP_FILE"

                log "finished"
            '';
        };

        timers.media-mover = {
            description = "Periodically check for incoming media to move";
            wantedBy = ["timers.target"];
            timerConfig = {
                OnBootSec = "1min";
                OnUnitActiveSec = "2min";
            };
        };
    };

    security.sudo.extraRules = [
        {
            users = ["admin"];
            commands = [
                {
                    command = "/run/current-system/sw/bin/systemctl start media-mover.service";
                    options = ["NOPASSWD"];
                }
            ];
        }
    ];
}
