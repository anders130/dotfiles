{
    config,
    lib,
    ...
}: {
    options.modules.hardware.sound = {
        enable = lib.mkEnableOption "Enable sound";
    };

    config = lib.mkIf config.modules.hardware.sound.enable {
        # Enable sound with pipewire.
        sound.enable = true;
        hardware.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
    };
}
