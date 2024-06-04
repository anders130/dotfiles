{
    config,
    lib,
    username,
    ...
}: {
    imports = [
        ./wsl.nix
    ];

    options = {
        modules.docker.enable = lib.mkEnableOption "docker";
    };

    config = lib.mkIf config.modules.docker.enable {
        virtualisation.docker = {
            enable = true;
            enableOnBoot = true;
            autoPrune.enable = true;
        };

        users.users.${username}.extraGroups = [
            "docker"
        ];
    };
}
