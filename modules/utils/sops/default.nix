{
    inputs,
    pkgs,
    username,
    ...
}: {
    imports = [inputs.sops-nix.nixosModules.sops];

    environment.systemPackages = with pkgs; [
        sops
        ssh-to-age
        age
    ];

    sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
}
