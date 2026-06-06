{
    den.aspects.nautilus = {
        nixos = {
            config,
            lib,
            pkgs,
            ...
        }: {
            options.my.nautilus.terminal = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Terminal command nautilus-open-any-terminal launches.";
            };
            config = {
                environment = {
                    systemPackages = [
                        (pkgs.nautilus.overrideAttrs (super: {
                            buildInputs =
                                super.buildInputs
                                ++ (with pkgs.gst_all_1; [
                                    gst-plugins-good
                                    gst-plugins-bad
                                    gst-plugins-ugly
                                ]);
                        }))
                        pkgs.nautilus-python
                    ];
                    sessionVariables.NAUTILUS_4_EXTENSION_DIR = lib.mkForce "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
                    pathsToLink = ["/share/nautilus-python/extensions"];
                };
                services = {
                    gvfs.enable = true;
                    gnome.localsearch.enable = true;
                };
                programs.nautilus-open-any-terminal = {
                    enable = true;
                    terminal = lib.mkIf (config.my.nautilus.terminal != null) config.my.nautilus.terminal;
                };
            };
        };
        homeManager = {
            xdg.userDirs = {
                enable = true;
                setSessionVariables = false;
            };
        };
    };
}
