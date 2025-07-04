{
    inputs,
    lib,
}: {
    imports = [inputs.hyprland.homeManagerModules.default];
    stylix.targets.hyprland.enable = false;
    xdg.configFile."hypr/extraConfig" = lib.mkSymlink ./_extraConfig; # TODO: function not available yet
}
