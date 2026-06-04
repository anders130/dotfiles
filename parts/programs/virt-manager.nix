{inputs, ...}: {
    flake.modules.nixos.virt-manager = {config, ...}: {
        programs.virt-manager.enable = true;
        virtualisation.libvirtd.enable = true;
        users.groups.libvirtd.members = config.users.normalUsers;
        users.groups.tss.members = config.users.normalUsers;
        security.tpm2 = {
            enable = true;
            pkcs11.enable = true;
            tctiEnvironment.enable = true;
        };
        home-manager.sharedModules = [inputs.self.modules.homeManager.virt-manager];
    };
    flake.modules.homeManager.virt-manager = {
        dconf.settings."org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
        };
    };
}
