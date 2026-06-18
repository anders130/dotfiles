{
    inputs,
    config,
    ...
}: let
    flakeCfg = config;
in {
    flake-file.inputs.disko.url = "github:nix-community/disko";
    den.aspects.disko = {
        nixos = {config, ...}: {
            imports = [inputs.disko.nixosModules.disko];
            _module.args.diskoInstall = {
                disks = config.disko.devices.disk;
                inherit (config.readme) preInstall;
                inherit (config.networking) hostName;
            };
        };
        readme = {
            diskoInstall,
            lib,
            ...
        }: let
            inherit (builtins) attrValues concatStringsSep;
            inherit (lib) concatLists mapAttrsToList;
            inherit (flakeCfg.readmeLib) cloneRepo heading join;
            inherit (diskoInstall) disks preInstall hostName;

            cell = v:
                if v == null
                then "-"
                else toString v;
            mkRow = cells: "| ${concatStringsSep " | " cells} |";
            row = disk: part:
                mkRow [disk (cell (part.size or null)) (cell (part.content.format or null)) (cell (part.content.mountpoint or null))];
            rows = concatLists (mapAttrsToList (disk: d: map (row disk) (attrValues d.content.partitions)) disks);
            table = concatStringsSep "\n" (
                [
                    (mkRow ["Disk" "Size" "Format" "Mount"])
                    (mkRow ["---" "---" "---" "---"])
                ]
                ++ rows
            );
        in {
            install = join (
                [
                    "Boot a NixOS live USB and clone this repo:"
                    cloneRepo
                ]
                ++ map (heading "###") preInstall
                ++ [
                    ''
                        Partition (**erases the disks below**) and install:

                        ${table}
                    ''
                    ''
                        ```bash
                        sudo nix run github:nix-community/disko -- --mode disko --flake .#${hostName}
                        nixos-install --flake .#${hostName}
                        ```
                    ''
                ]
            );
        };
    };
}
