{
    pkgs,
    username,
    ...
}: {
    users.users.${username}.extraGroups = ["dialout"];
    environment.systemPackages = with pkgs; [
        chromium
    ];
}
