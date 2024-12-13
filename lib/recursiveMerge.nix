{lib, ...}: lib.fix (merge: sets:
    lib.foldl' (acc: set:
        acc // lib.mapAttrs (k: v:
            if lib.isAttrs v && lib.hasAttr k acc then
                merge [acc.${k} v]
            else if lib.isList v && lib.hasAttr k acc && lib.isList acc.${k} then
                acc.${k} ++ v
            else if lib.isString v && lib.hasAttr k acc && lib.isString acc.${k} then
                acc.${k} + "\n" + v
            else v)
        set
    ) {} sets
)
