{
    config,
    lib,
    username,
    ...
}: {
    options = {
        modules.virt-manager.enable = lib.mkEnableOption "virt-manager";
    };

    config = lib.mkIf config.modules.virt-manager.enable {
        programs.virt-manager.enable = true;

        # libvirtd
        virtualisation.libvirtd.enable = true;
        users.users.${username}.extraGroups = ["libvirtd" "tss"];
        security.tpm2.enable = true;
        security.tpm2.pkcs11.enable = true;
        security.tpm2.tctiEnvironment.enable = true;

        home-manager.users.${username} = {
            dconf.settings."org/virt-manager/virt-manager/connections" = {
                autoconnect = ["qemu:///system"];
                uris = ["qemu:///system"];
            };
        };
    };
}
