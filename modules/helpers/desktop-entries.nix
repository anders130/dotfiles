{
    den.aspects.desktop-entries.nixos = {
        config,
        lib,
        ...
    }: {
        options.my.desktop-entries = lib.mkOption {
            type = lib.types.attrsOf (lib.types.submodule {
                freeformType = lib.types.attrs;
                options.package = lib.mkOption {
                    type = lib.types.str;
                    description = "Attribute name of the package to override, e.g. \"vesktop\".";
                };
            });
            default = {};
            description = "Override a package's .desktop entry. Fields go to makeDesktopItem; a field may be a function of prev.";
        };

        config.nixpkgs.overlays = lib.mapAttrsToList (
            _: entry: _: prev: let
                resolve = v:
                    if lib.isFunction v
                    then v prev
                    else v;
                fields = lib.mapAttrs (_: resolve) (removeAttrs entry ["package"]);
            in {
                ${entry.package} = prev.${entry.package}.overrideAttrs (_: {
                    desktopItems = [(prev.makeDesktopItem fields)];
                });
            }
        )
        config.my.desktop-entries;
    };
}
