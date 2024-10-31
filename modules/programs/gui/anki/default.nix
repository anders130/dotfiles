{
    config,
    lib,
    pkgs,
    username,
    ...
}: let
    recolorAddonCode = "688199788";
in {
    options.modules.programs.gui.anki = {
        enable = lib.mkEnableOption "anki";
    };

    config = lib.mkIf config.modules.programs.gui.anki.enable {
        environment.systemPackages = [
            pkgs.anki-bin
        ];

        home-manager.users.${username} = {config, ...}: {
            home.file.".local/share/Anki2/addons21/${recolorAddonCode}/config.json" = lib.mkSymlink config {
                source = "modules/programs/gui/anki/theme.json";
            };
        };
    };
}
