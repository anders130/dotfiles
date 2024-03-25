{
    config,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
    ];
    boot.supportedFilesystems = [ "ntfs" "exfat" ];
    
    # Nvidia gpu
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        open = false;
        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.stable;
    }; 
    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };

    # Audio
    ## Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };
}
