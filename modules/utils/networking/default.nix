{
    config,
    hostname,
    lib,
    username,
    ...
}: {
    options.utils.user = {
        enable = lib.mkEnableOption "user";
    };

    config = lib.mkIf config.utils.user.enable {
        networking = {
            inherit hostname;
            firewall.enable = lib.mkDefault true;
            networkmanager.enable = lib.mkDefault true;
        };

        users.users.${username}.extraGroups = [
            "networkmanager"
        ];
    };
}
