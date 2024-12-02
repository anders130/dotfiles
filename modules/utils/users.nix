{
    hashedPassword,
    username,
    lib,
    ...
}: {
    users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
            "networkmanager"
        ];
    } // lib.optionalAttrs (hashedPassword != null) {
        hashedPassword = hashedPassword;
    };
}
