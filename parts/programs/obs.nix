{inputs, ...}: {
    flake.modules.nixos.obs = {config, ...}: {
        boot = {
            kernelModules = ["v4l2loopback"];
            extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
            extraModprobeConfig = ''
                options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
            '';
        };
        security.polkit.enable = true;
        home-manager.sharedModules = [inputs.self.modules.homeManager.obs];
    };
    flake.modules.homeManager.obs = {pkgs, ...}: {
        programs.obs-studio = {
            enable = true;
            plugins = with pkgs.obs-studio-plugins; [obs-backgroundremoval];
        };
    };
}
