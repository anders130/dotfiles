{
    lib,
    pkgs,
    ...
}: let
    inherit (builtins) elemAt filter;
    inherit
        (lib)
        concatMap
        hasInfix
        mapAttrsToList
        mkEnableOption
        mkIf
        mkOption
        optionalAttrs
        removePrefix
        splitString
        types
        ;
in {
    options = {
        devices = mkOption {
            type = types.attrsOf (types.submodule {
                options = {
                    type = mkOption {
                        type = types.enum ["alsa" "bluez5"];
                        default = "alsa";
                        description = "Device API type (alsa or bluez5).";
                    };
                    match = mkOption {
                        type = types.attrs;
                        description = "Matching rules for the device.";
                    };
                    profile = mkOption {
                        type = types.str;
                        description = "Profile to apply to the device.";
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
    config = cfg: let
        devicesList = mapAttrsToList (name: device: {
            inherit name;
            inherit (device) type match profile;
        })
        cfg.devices;
        mkDeviceRule = d: {
            matches = [d.match];
            actions.update-props = {
                "device.profile" = d.profile;
                "device.nick" = d.name;
                "device.description" = d.name;
            };
        };
        mkNodeRules = d: let
            cardId = removePrefix "alsa_card." d.match."device.name";
            mkRule = direction: suffix: {
                matches = [{"node.name" = "alsa_${direction}.${cardId}.${suffix}";}];
                actions.update-props = {
                    "node.description" = d.name;
                    "node.nick" = d.name;
                };
            };
            parsePart = part:
                if hasInfix ":" part
                then let
                    parts = splitString ":" part;
                in [(mkRule (elemAt parts 0) (elemAt parts 1))]
                else [(mkRule "output" part) (mkRule "input" part)];
        in
            concatMap parsePart (splitString "+" d.profile);
        hasNodeName = d: d.profile != "off" && d.match ? "device.name";
        mkRules = devices: let
            deviceRules = map mkDeviceRule devices;
            nodeRules = concatMap mkNodeRules (filter hasNodeName devices);
        in
            deviceRules ++ nodeRules;
        alsaDevices = filter (d: d.type == "alsa") devicesList;
        bluezDevices = filter (d: d.type == "bluez5") devicesList;
    in {
        security.rtkit.enable = true; # realtime scheduling for pipewire
        services = {
            pulseaudio.enable = false;
            pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
            };
            pipewire.wireplumber.extraConfig = mkIf (cfg.devices != {}) {
                "90-custom-audio" =
                    optionalAttrs (alsaDevices != []) {"monitor.alsa.rules" = mkRules alsaDevices;}
                    // optionalAttrs (bluezDevices != []) {"monitor.bluez.rules" = map mkDeviceRule bluezDevices;};
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
    };
}
