{
    dots.desktop.provides.hyprland.homeManager = {
        config,
        lib,
        ...
    }: let
        inherit (lib) types mkOption concatLists mapAttrsToList optional filterAttrs;
        inherit (lib.generators) mkLuaInline toLua;
        inherit (builtins) isAttrs;

        dispatchExpr = {
            ns,
            fn,
            arg ? null,
        }: "${ns}.${fn}(${
            if arg == null
            then ""
            else toLua {} arg
        })";

        normalizeBind = value:
            if isAttrs value && value ? dispatch
            then {
                inherit (value) dispatch;
                opts = value.opts or null;
            }
            else {
                dispatch = value;
                opts = null;
            };

        renderBind = key: raw: let
            bind = normalizeBind raw;
        in {
            _args =
                [key (mkLuaInline (dispatchExpr bind.dispatch))]
                ++ optional (bind.opts != null) bind.opts;
        };
    in {
        options.my.hyprland.binds = mkOption {
            type = types.attrsOf (types.nullOr (
                types.coercedTo (types.either types.str types.attrs) (v: [v]) (types.listOf types.anything)
            ));
            default = {};
            description = ''
                Keybinds, keyed by hl.bind's own key string (e.g. "SUPER + C").
            '';
        };

        config.wayland.windowManager.hyprland.settings.bind =
            config.my.hyprland.binds
            |> filterAttrs (_: entries: entries != null)
            |> mapAttrsToList (key: map (renderBind key))
            |> concatLists;
    };
}
