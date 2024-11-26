{username, ...}: {
    programs.virt-manager.enable = true;

    # libvirtd
    virtualisation.libvirtd.enable = true;
    users.users.${username}.extraGroups = ["libvirtd" "tss"];
    security.tpm2 = {
        enable = true;
        pkcs11.enable = true;
        tctiEnvironment.enable = true;
    };

    home-manager.users.${username} = {
        dconf.settings."org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
        };
    };
}
