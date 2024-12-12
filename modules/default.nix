args @ {
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (builtins) any attrNames attrValues baseNameOf concatMap dirOf filter foldl' groupBy isAttrs readDir;
    inherit (lib) mkModule mkRelativePath recursiveMerge removeSuffix splitString;

    pathToKeys = path: path
        |> mkRelativePath
        |> removeSuffix ".nix"
        |> removeSuffix "/default" # default should not be in the module set path
        |> splitString "/";

    # Resolve the cfg value for a file based on its path
    resolveCfg = path: foldl' (obj: key: obj.${key}) config (pathToKeys path);

    getRelevantFiles = dir: dir
        |> lib.filesystem.listFilesRecursive # list all files in the directory
        |> filter (n: lib.strings.hasSuffix ".nix" n) # only nix files
        |> filter (n: n != ./default.nix) # filter out this file
        # filter out files that are in the same directory as a default.nix file
        |> groupBy (file: toString (dirOf file)) # group by directory
        |> attrValues # convert to list of lists
        |> concatMap (group:
            if any (file: baseNameOf file == "default.nix") group # if dir contains a default.nix file
            then filter (file: baseNameOf file == "default.nix") group # only include default.nix files
            else group # otherwise include all files
        );

    importModule = file: let
        module = import file;
    in
        if isAttrs module then module
        else module (args // {
            inherit pkgs;
            lib = lib // { # simplify lib for modules
                mkSymlink = lib.mkSymlink config.hm;
            };
        });

    processModule = moduleFile: let
        module = importModule moduleFile;
        subModules = if baseNameOf moduleFile != "default.nix" then [] else moduleFile
            |> dirOf
            |> readDir
            |> attrNames
            |> filter (n: lib.strings.hasSuffix ".nix" n) # only nix files
            |> filter (n: baseNameOf n != "default.nix")
            |> map (file: file
                |> (x: toString (dirOf moduleFile) + "/" + x) # get the full path of the file
                |> importModule
            );
        cfg = resolveCfg moduleFile;
    in (subModules ++ [module])
        |> map (set:
            if set ? config && !isAttrs set.config
            then set // {config = set.config cfg;}
            else set
        )
        |> recursiveMerge;
in {
    imports = ./.
        |> getRelevantFiles
        |> map (file: file
            |> processModule
            |> mkModule config file
        );
}
