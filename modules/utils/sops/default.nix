{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: lib.mkModule config ./. {
    imports = [
        inputs.sops-nix.nixosModules.sops
    ];

    config = {
        environment.systemPackages = with pkgs; [
            sops
            ssh-to-age
            age
        ];

        sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    };
}
