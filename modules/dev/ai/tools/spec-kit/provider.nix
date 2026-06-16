{
    den.aspects.ai.provides.skills.spec-kit.homeManager = {
        self',
        lib,
        ...
    }: let
        inherit (self'.packages) spec-kit-skills;
        inherit (lib) filterAttrs mapAttrs' mapAttrsToList mkDefault mkMerge nameValuePair;

        entriesOf = path:
            if builtins.pathExists path
            then builtins.readDir path
            else {};
        dirsOf = path: filterAttrs (_: type: type == "directory") (entriesOf path);

        # Symlink every entry of `src` into `prefix`, wrapping each with `prio`.
        linkInto = prio: prefix: src:
            entriesOf src
            |> mapAttrs' (name: _: nameValuePair "${prefix}/${name}" (prio {source = "${src}/${name}";}));

        skillsSrc = "${spec-kit-skills}/skills";
        extDir = "${spec-kit-skills}/extensions";
    in {
        my.ai.providers.spec-kit.skills =
            dirsOf skillsSrc |> mapAttrs' (name: _: nameValuePair name "${skillsSrc}/${name}");

        home.file = mkMerge (
            [
                (linkInto lib.id ".specify/scripts/bash" "${spec-kit-skills}/scripts/bash")
                (linkInto lib.id ".specify/templates" "${spec-kit-skills}/templates")
            ]
            # Each extension's scripts go to their own dir, and are flattened into
            # the shared scripts dir (mkDefault so core scripts win on name clash).
            ++ mapAttrsToList (
                ext: _: let
                    src = "${extDir}/${ext}/scripts/bash";
                in
                    mkMerge [
                        (linkInto lib.id ".specify/extensions/${ext}/scripts/bash" src)
                        (linkInto mkDefault ".specify/scripts/bash" src)
                    ]
            ) (dirsOf extDir)
        );
    };
}
