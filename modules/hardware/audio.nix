{
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mapAttrsToList mkEnableOption mkIf mkOption types;
in {
    options = {
        devices = mkOption {
            type = types.attrsOf (types.submodule {
                options = {
                    match = mkOption {
                        type = types.attrs;
                        description = "Matching rules for the device";
                    };
                    profile = mkOption {
                        type = types.str;
                        description = "Profile to apply to the device";
                    };
                };
            });
            default = {};
        };
        disableAutoMute = mkEnableOption ''
            Disable auto-mute on boot.
            This prohibits the computer from automatically muting speakers when the headphones are plugged in.
        '';
    };
    config = cfg: {
        security.rtkit.enable = true; # realtime scheduling for pipewire
        services = {
            pulseaudio.enable = false;
            pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
            };
        };
        systemd.user.services.disable-auto-mute = mkIf cfg.disableAutoMute {
            description = "Disable auto-mute on boot";
            script = ''
                amixer -c Generic sset 'Auto-Mute Mode' 'Disabled'
            '';
            path = [pkgs.alsa-utils];
            after = [
                "pipewire.target"
                "default.target"
            ];
            wantedBy = ["default.target"];
        };
        services.pipewire.wireplumber.extraConfig = mkIf (cfg.devices != {}) {
            "90-custom-audio"."monitor.alsa.rules" =
                cfg.devices
                |> mapAttrsToList (name: device: {
                    matches = [device.match];
                    actions.update-props = {
                        "device.profile" = device.profile;
                        "device.nick" = name;
                        "device.description" = name;
                        "node.description" = name;
                    };
                });
        };
    };
}
