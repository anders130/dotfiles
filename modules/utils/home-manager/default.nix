{
    config,
    inputs,
    lib,
    username,
    ...
}: {
    imports = [
        inputs.home-manager.nixosModules.home-manager
    ];

    options.modules.utils.home-manager = {
        enable = lib.mkEnableOption "home-manager";
    };

    config.home-manager = lib.mkIf config.modules.utils.home-manager.enable {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username}.home = {
            inherit username;
            stateVersion = config.system.stateVersion;
            homeDirectory = "/home/${username}";
        };
    };
}
