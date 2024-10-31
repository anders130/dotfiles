{
    config,
    hashedPassword,
    lib,
    username,
    ...
}: {
    options.utils.user = {
        enable = lib.mkEnableOption "user";
    };

    config = lib.mkIf config.utils.user.enable {
        users.users.${username} = {
            isNormalUser = true;
            extraGroups = [
                "wheel"
            ];
        } // lib.optionalAttrs (hashedPassword != null) {
            hashedPassword = hashedPassword;
        };
    };
}
