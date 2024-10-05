{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: {
    imports = [
        inputs.sops-nix.nixosModules.sops
    ];

    options.modules.sops = {
        enable = lib.mkEnableOption "sops";
    };

    config = lib.mkIf config.modules.sops.enable {
        environment.systemPackages = with pkgs; [
            sops
            ssh-to-age
            age
        ];

        sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    };
}
