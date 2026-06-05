{
    dots,
    inputs,
    ...
}: {
    flake-file.inputs.lsfg-vk-flake.url = "github:pabloaul/lsfg-vk-flake/main";
    den.aspects.jesse-desktop = {
        includes = [dots.gaming];
        nixos = {
            imports = [inputs.lsfg-vk-flake.nixosModules.default];
            services = {
                flatpak.enable = true;
                lsfg-vk = {
                    enable = true;
                    ui.enable = true;
                };
            };
        };
    };
}
