{
    hostname,
    lib,
    ...
}: {
    networking = {
        firewall.enable = lib.mkDefault true;
        hostName = "${hostname}";
        networkmanager.enable = lib.mkDefault true;
    };
}
