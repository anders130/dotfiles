{...}: args: let
    inherit (builtins) readDir filter map attrNames elem isAttrs;
    path =
        if isAttrs args
        then args.path
        else args;
    exclude =
        if isAttrs args && args ? exclude
        then args.exclude
        else ["default.nix"];
in
    map (fn: path + "/${fn}")
    (filter (fn: !(elem fn exclude)) (attrNames (readDir path)))
