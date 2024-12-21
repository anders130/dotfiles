args @ {
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (builtins) any attrValues baseNameOf concatMap dirOf filter groupBy head isAttrs;
    inherit (lib.lists) flatten;

    importModule = file: let
        module = import file;
    in
        if isAttrs module then module
        else module (args // {
            inherit pkgs;
            lib = lib // {
                mkSymlink = lib.mkSymlink config.hm;
            };
        });

    getFiles = dir: dir
        |> lib.filesystem.listFilesRecursive # list all files in the directory
        |> filter (n: lib.strings.hasSuffix ".nix" n) # only nix files
        |> filter (n: n != ./default.nix) # filter out this file
        |> groupBy (file: toString (dirOf file))
        |> attrValues
        # move files into its own list when there is no default.nix file
        |> concatMap (files:
            if any (file: baseNameOf file == "default.nix") files
            then [files] # Keep as a list
            else map (file: [file]) files # Spread into the parent list
        )
    ;

    getMainFile = files:
        if any (file: baseNameOf file == "default.nix") files
        then filter (file: baseNameOf file == "default.nix") files
        else files;

    mkModules = files: let
        mainFile = head (getMainFile files);
    in
        files
        # |> (x: lib.debug.traceSeq {inherit x mainFile;} x)
        |> map (file: file
            |> importModule
            # |> (x: lib.debug.traceSeq {inherit file mainFile; equal = file == mainFile;} x)
            |> lib.mkModule config (file == mainFile) mainFile
        )
    ;
in {
    imports = ./.
        |> getFiles
        # |> map (x: lib.debug.traceSeq x x)
        |> map mkModules
        |> flatten
    ;
}
