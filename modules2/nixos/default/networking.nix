{
    hostName,
    lib,
}: {
    inherit hostName;
    firewall.enable = lib.mkDefault true;
    networkmanager.enable = lib.mkDefault true;
}
