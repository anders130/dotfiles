{inputs, ...}: {
    flake.modules.nixos.virt-manager = {username, ...}: {
        programs.virt-manager.enable = true;
        virtualisation.libvirtd.enable = true;
        users.users.${username}.extraGroups = ["libvirtd" "tss"];
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
