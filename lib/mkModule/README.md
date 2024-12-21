## Usage of `lib.mkModule`

1. Just the config

   ```nix
   {
       config,
       lib,
       ...
   }: lib.mkModule config true ./. {
       yourModuleOptions = true;
   }
   ```

2. Explicitly set name, imports and additional options:

   ```nix
   {
       config,
       lib,
       ...
   }: lib.mkModule config true ./. {
       name = "myModule";
       imports = [
           ./myModule.nix
       ];
       options = {
           myModuleOption = lib.mkOption {
               type = lib.types.bool;
               default = false;
           };
       };
       config = {
           yourModuleOption = true;
       };
   }
   ```

3. You can also use the values of the custom options in the config:

   ```nix
   {
       config,
       lib,
       ...
   }: lib.mkModule config true ./. {
       name = "myModule";
       imports = [
           ./myModule.nix
       ];
       options = {
           myModuleOption = lib.mkOption {
               type = lib.types.bool;
               default = false;
           };
       };
       config = cfg: {
           yourModuleOption = cfg.myModuleOption;
       }
   }
   ```
