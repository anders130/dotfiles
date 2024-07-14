{
    config,
    lib,
    pkgs,
    ...
}: let
    package = pkgs.gnome.nautilus.overrideAttrs (super: {
        buildInputs = super.buildInputs ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
            gst-plugins-ugly
        ]);
    });
in {
    options.modules.nautilus = {
        enable = lib.mkEnableOption "nautilus";
    };

    config = lib.mkIf config.modules.nautilus.enable {
        environment.systemPackages = [
            package
        ];

        services.gvfs.enable = true; # for trash to work

        programs.nautilus-open-any-terminal = {
            enable = true;
            terminal = "alacritty"; # TODO: make this configurable
        };
    };
}
