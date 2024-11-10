{
    config,
    lib,
    pkgs,
    username,
    ...
}: let
    cfg = config.modules.applications.nautilus;
in {
    options.modules.applications.nautilus = {
        enable = lib.mkEnableOption "nautilus";
        terminal = lib.mkOption {
            type = lib.types.str;
        };
    };

    config = lib.mkIf cfg.enable {
        environment = {
            systemPackages = [
                (pkgs.nautilus.overrideAttrs (super: {
                    buildInputs = super.buildInputs ++ (with pkgs.gst_all_1; [
                        gst-plugins-good
                        gst-plugins-bad
                        gst-plugins-ugly
                    ]);
                }))
                pkgs.nautilus-python
            ];

            sessionVariables.NAUTILUS_4_EXTENSION_DIR = lib.mkForce "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
            pathsToLink = [
                "/share/nautilus-python/extensions"
            ];
        };

        services.gvfs.enable = true; # for trash to work

        programs.nautilus-open-any-terminal = {
            enable = true;
            terminal = cfg.terminal;
        };

        home-manager.users.${username} = {
            xdg.userDirs.enable = true;
        };

        services.gnome.localsearch.enable = true;
    };
}
