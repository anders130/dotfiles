{
    config,
    lib,
    ...
}: {
    options.utils.localization = {
        enable = lib.mkEnableOption "localization";
    };

    config = lib.mkIf config.utils.localization.enable {
        time.timeZone = "Europe/Berlin";

        i18n = {
            # Select internationalisation properties.
            defaultLocale = "en_US.UTF-8";

            extraLocaleSettings = {
                LC_ADDRESS = "de_DE.UTF-8";
                LC_IDENTIFICATION = "de_DE.UTF-8";
                LC_MEASUREMENT = "de_DE.UTF-8";
                LC_MONETARY = "de_DE.UTF-8";
                LC_NAME = "de_DE.UTF-8";
                LC_NUMERIC = "de_DE.UTF-8";
                LC_PAPER = "de_DE.UTF-8";
                LC_TELEPHONE = "de_DE.UTF-8";
                LC_TIME = "de_DE.UTF-8";
            };
        };
    };
}
