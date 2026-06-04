{
    config,
    inputs,
    ...
}: {
    flake-file.inputs.lsfg-vk-flake.url = "github:pabloaul/lsfg-vk-flake/main";
    flake.modules.nixos.jesse-desktop = {
        imports = [
            inputs.lsfg-vk-flake.nixosModules.default
            config.flake.modules.nixos.gaming
        ];
        services = {
            flatpak.enable = true;
            lsfg-vk = {
                enable = true;
                ui.enable = true;
            };
        };
    };
}
