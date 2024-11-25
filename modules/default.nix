{
    config,
    lib,
    ...
}: let
    inherit (builtins) any attrValues baseNameOf concatMap dirOf filter groupBy;
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
in {
    imports = getFiles ./.;
}
