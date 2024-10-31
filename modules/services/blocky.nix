{
    config,
    lib,
    ...
}: {
    options.modules.services.blocky = {
        enable = lib.mkEnableOption "blocky";
    };

    config = lib.mkIf config.modules.services.blocky.enable {
        networking.firewall = {
            allowedTCPPorts = [
                53
            ];
            allowedUDPPorts = [
                53
            ];
        };

        networking.nameservers = ["1.1.1.1" "1.0.0.1"];

        services.blocky = {
            enable = true;

            settings = {
                upstreams.groups.default = [
                    "1.1.1.1"
                    "1.0.0.1"
                ];

                blocking = {
                    blackLists = {
                        ads = [
                            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                        ];
                        slack = ["|\nwww.youtube.com\nwww.google.com"];
                    };

                    clientGroupsBlock = {
                        default = [
                            "ads"
                            "slack"
                        ];
                    };
                };
                ports.dns = 53;
            };
        };
    };
}
