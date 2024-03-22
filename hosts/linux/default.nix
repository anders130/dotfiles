{
    ...
}: {
    imports = [
        ./hardware-configuration.nix
    ];
    boot.supportedFilesystems = [ "ntfs" "exfat" ];
}
