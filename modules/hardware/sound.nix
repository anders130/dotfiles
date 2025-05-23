{pkgs, ...}: {
    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    systemd.user.services.disable-auto-mute = {
        description = "Disable auto-mute on boot";
        script = ''
            amixer -c Generic sset 'Auto-Mute Mode' 'Disabled'
        '';
        path = [pkgs.alsa-utils];
        after = [
            "pipewire.target"
            "default.target"
        ];
        wantedBy = ["default.target"];
    };
}
