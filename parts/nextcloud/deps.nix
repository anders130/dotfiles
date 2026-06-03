{config, ...}: {
    flake.modules.homeManager.nextcloud = {
        imports = with config.flake.modules.homeManager; [
            initial-files
        ];
    };
}
