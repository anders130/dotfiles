## Usage of `lib.importFromDir`

1. Just the path

   ```nix
   {lib, ...}: {
       imports = lib.importFromDir ./.;
   }
   ```

   This will import all files in the current directory except for `default.nix`.

2. Path with custom exclusions:

   ```nix
   {lib, ...}: {
       imports = lib.importFromDir {
           path = ./.;
           exclude = ["default.nix" "README.md"];
       };
   }
   ```
