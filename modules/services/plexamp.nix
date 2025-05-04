{
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkOption types;
    imageVersion =
        if pkgs.system == "x86_64-linux"
        then "amd64"
        else "arm64v8";
in {
    options = {
        claimToken = mkOption {
            type = types.str;
            description = "Plex Claim Token, go to https://plex.tv/claim and paste it here";
        };
        playerName = mkOption {
            type = types.str;
            description = "Plex Player Name. This shows up in the plexamp app as the name of the device";
            default = config.networking.hostName or "podman-container";
        };
        dataDir = mkOption {
            type = types.str;
            description = "Plexamp Data Directory";
            default = "/var/lib/plexamp";
        };
    };

    config = cfg: {
        networking.firewall.allowedTCPPorts = [
            32500
            20000
        ];

        virtualisation.oci-containers.containers.plexamp = {
            image = "ghcr.io/anatosun/plexamp:${imageVersion}-4.12.2";
            # image = "docker.io/moritzf/plexamp:latest";
            ports = [
                "127.0.0.1:32500:32500"
                "127.0.0.1:20000:20000"
            ];
            environment = {
                PLEXAMP_CLAIM_TOKEN = cfg.claimToken;
                PLEXAMP_PLAYER_NAME = cfg.playerName;
            };
            volumes = [
                "${cfg.dataDir}:/root/.local/share/Plexamp"
            ];
            extraOptions = [
                "--device=/dev/snd:/dev/snd" # replace with the devices option when it's merged into stable
                "--privileged"
                "--network=host"
            ];
        };

        systemd.tmpfiles.rules = [
            "d ${cfg.dataDir} 0755 root root - -"
        ];
    };
}
