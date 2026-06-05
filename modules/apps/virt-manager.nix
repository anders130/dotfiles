{
    den.aspects.virt-manager = {
        nixos = {config, ...}: {
            programs.virt-manager.enable = true;
            virtualisation.libvirtd.enable = true;
            users.groups.libvirtd.members = config.users.normalUsers;
            users.groups.tss.members = config.users.normalUsers;
            security.tpm2 = {
                enable = true;
                pkcs11.enable = true;
                tctiEnvironment.enable = true;
            };
        };
        homeManager = {
            dconf.settings."org/virt-manager/virt-manager/connections" = {
                autoconnect = ["qemu:///system"];
                uris = ["qemu:///system"];
            };
        };
    };
}
