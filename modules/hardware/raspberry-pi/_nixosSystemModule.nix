{
    inputs,
    lib,
    modulesPath,
    ...
}: {
    imports = with inputs.nixos-raspberrypi.nixosModules; [
        sd-image
        trusted-nix-caches
        inputs.nixos-raspberrypi.lib.inject-overlays
        (lib.mkAliasOptionModule ["environment" "checkConfigurationOptions"] ["_module" "check"])
    ];
    disabledModules = [(modulesPath + "/rename.nix")];

    boot.supportedFilesystems.zfs = lib.mkForce false;
}
