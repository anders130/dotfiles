{
    den.aspects.nautilus = {
        nixos = {
            lib,
            pkgs,
            ...
        }: {
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
                terminal = "kitty";
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
