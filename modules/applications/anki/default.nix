{
    lib,
    pkgs,
    username,
    ...
}: let
    recolorAddonCode = "688199788";
in {
    environment.systemPackages = [pkgs.anki];

    home-manager.users.${username} = {config, ...}: {
        home.file.".local/share/Anki2/addons21/${recolorAddonCode}/config.json" = lib.mkSymlink config ./theme.json;
    };
}
