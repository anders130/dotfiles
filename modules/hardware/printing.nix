{
    config,
    lib,
    pkgs,
    ...
}: {
    options.modules.hardware.printing = {
        enable = lib.mkEnableOption "Enable printing";
    };

    config = lib.mkIf config.modules.hardware.printing.enable {
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
    };
}
