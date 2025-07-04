{
    hashedPassword,
    username,
    lib,
}: {
    users.${username} =
        {
            isNormalUser = true;
            extraGroups = [
                "wheel"
                "networkmanager"
            ];
        }
        // lib.optionalAttrs (hashedPassword != null) {
            inherit hashedPassword;
        };
}
