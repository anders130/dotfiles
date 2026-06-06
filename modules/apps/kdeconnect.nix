{
    den.aspects.kdeconnect = {
        homeManager = {pkgs, ...}: {
            services.kdeconnect = {
                enable = true;
                package = pkgs.kdePackages.kdeconnect-kde;
                indicator = true;
            };
        };
        nixos.networking.firewall = rec {
            allowedTCPPortRanges = [
                {
                    from = 1714;
                    to = 1764;
                }
            ];
            allowedUDPPortRanges = allowedTCPPortRanges;
        };
    };
}
