{inputs, ...}: {
    imports = [inputs.flake-follows.flakeModules.flake-follows];
    flake-file.inputs = {
        flake-follows.url = "github:anders130/flake-follows";
        # deduplicate
        flake-utils.url = "github:numtide/flake-utils";
        flake-compat.url = "github:edolstra/flake-compat";
        import-tree.url = "github:denful/import-tree";
        systems.url = "github:nix-systems/default-linux";
        nixpkgs-lib.follows = "nixpkgs";
    };
}
