{
    dots.desktop.provides.hyprland.homeManager = {
        config,
        lib,
        ...
    }: {
        # keyed by "MODS, KEY" -> "dispatcher, args" so consumers override or
        # extend individual binds instead of appending a conflicting list.
        # set a key to null to remove a preset bind.
        options.my.hyprland.binds = lib.mkOption {
            type = lib.types.attrsOf (lib.types.nullOr lib.types.str);
            default = {};
        };

        config = {
            wayland.windowManager.hyprland.settings = {
                input = with config.home.keyboard; {
                    kb_layout = layout;
                    kb_variant = variant;
                    kb_model = "";
                    kb_options = options;
                    kb_rules = "";
                    numlock_by_default = true;
                    repeat_delay = 250;
                    repeat_rate = 25;
                    follow_mouse = 1;
                    mouse_refocus = 0;
                    touchpad.natural_scroll = true;
                    sensitivity = 0;
                };
                bind = lib.mapAttrsToList (combo: action: "${combo}, ${action}") (
                    lib.filterAttrs (_: action: action != null) config.my.hyprland.binds
                );
                bindm = [
                    # Move/resize windows with mainMod + LMB/RMB and dragging
                    "SUPER, mouse:272, movewindow"
                    "SUPER, mouse:273, resizewindow"
                ];
            };

            # default binds (mkDefault so consumers can override per-key).
            # only generic tiling-WM mechanics + workspaces; opinionated choices
            # (which key launches what, movement style, personal apps, autostart)
            # are left to the consumer / my own desktop layer.
            my.hyprland.binds = let
                workspaces =
                    builtins.genList (x: toString (x + 1)) 9
                    |> map (i: [
                        {
                            name = "SUPER, ${i}";
                            value = "split:workspace, ${i}";
                        }
                        {
                            name = "SUPER Shift, ${i}";
                            value = "split:movetoworkspace, ${i}";
                        }
                    ])
                    |> builtins.concatLists
                    |> builtins.listToAttrs;
            in
                lib.mapAttrs (_: lib.mkDefault) ({
                    "SUPER, C" = "killactive";
                    "SUPER, V" = "togglefloating";
                    "SUPER, F" = "fullscreen";
                    "SUPER, S" = "layoutmsg, togglesplit";
                    "SUPER, P" = "pin";
                }
                // workspaces);
        };
    };
}
