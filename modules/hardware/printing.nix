{
    config,
    lib,
    pkgs,
    ...
}: lib.mkModule config ./printing.nix {
    # Enable CUPS to print documents.
    services.printing = {
        enable = true;
        drivers = [pkgs.hplip];
    };
    # Enable printer autodiscovery
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };
}
