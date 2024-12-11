args@{
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (builtins) any attrValues baseNameOf concatMap dirOf filter groupBy isAttrs elemAt length;
    inherit (lib) foldr mkIf removeSuffix splitString;

    getFiles = dir: dir
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


    pathToList = path: path
        |> lib.mkRelativePath
        |> removeSuffix ".nix"
        |> removeSuffix "/default" # if path is a default.nix, remove it
        |> splitString "/";

    getCfg = path: path
        |> pathToList
        |> lib.foldl' (obj: key: obj.${key}) config;

    mkModule = hostConfig: path: {
        imports ? [],
        options ? {},
        config ? null,
        ...
    } @ args: let
        pathList = pathToList path;
        configName = elemAt (length - 1) pathList; # last element of the path
        cfg = getCfg pathList;

        adjustConfig = config: config
            |> (c: removeAttrs c ["imports"]);
    in {
        imports = imports ++ config.imports or [];
        options = options
            |> (o: o // {enable = lib.mkEnableOption configName;})
            |> (o: foldr (key: acc: {${key} = acc;}) o pathList); # set the value at the path
        config = config
            |> (c: if c != null then c else args) # if config is not set, assume args are the config
            # |> (c: if isAttrs c then c else (c cfg)) # if config is a function, call it with cfg
            |> adjustConfig
            |> mkIf cfg.enable; # only enable if cfg.enable is true
    };

    moduleArgs = args // {
        inherit pkgs;
        lib = lib // {
            mkSymlink = lib.mkSymlink config.hm;
        };
    };

    mkModules = files: map (file: file
        |> import # import file
        |> (f: if isAttrs f then f else f moduleArgs) # if file is a function, call it with args
        |> lib.mkModule config file # convert to module
    ) files;

    mkModules2 = files: map (moduleFile: moduleFile
        |> import
        # if file is a function, call it with args
        |> (f: if isAttrs f then f else f moduleArgs)
        # if file is default.nix, look for nix files in the same directory and recursively merge them into the module
        |> (set:
            if baseNameOf moduleFile != "default.nix"
            then set
            else builtins.readDir (dirOf moduleFile)
                |> builtins.attrNames
                |> filter (n: baseNameOf n != "default.nix")
                |> map (file: file
                    |> (x: toString (dirOf moduleFile) + "/" + x) # get the full path of the file
                    |> import
                    |> (f: if isAttrs f then f else f moduleArgs)
                )
                |> (sets: sets ++ [set])
                # |> map (set: lib.debug.traceSeq {normal = isAttrs set.config; inherit set;} set)
                |> map (set: if !(set ? config) then set else
                    if isAttrs set.config
                    then set
                    else set // {config = (set.config (config.modules.ags));}
                )
                |> map (set: lib.debug.traceSeq {inherit set;} set)
                |> lib.recursiveMerge
                |> (x: lib.debug.traceSeq {inherit x;} set)
        )
        |> lib.mkModule config moduleFile
    ) files;
in {
    imports = ./.
        |> getFiles
        |> mkModules2;
}
