{
    flake.modules.nixos.default = {
        config,
        lib,
        ...
    }: let
        inherit (builtins) concatStringsSep filter head;
        inherit (lib) mkOption types unique mapAttrsToList;
        cfg = config.hardware.keyboard;
        userLayouts =
            config.home-manager.users
            |> mapAttrsToList (_: u: u.home.keyboard.layout)
            |> filter (l: l != null && l != "");
        allLayouts = unique ([cfg.defaultLayout] ++ userLayouts);
    in {
        options.hardware.keyboard.defaultLayout = mkOption {
            type = types.str;
            default = "us";
            example = "de";
            description = "Default keyboard layout for the console and display manager.";
        };
        config = {
            services.xserver.xkb.layout = concatStringsSep "," allLayouts;
            console.keyMap = head allLayouts;
        };
    };
}
