{inputs, ...}: {
    flake-file.inputs.sops-nix.url = "github:Mic92/sops-nix";
    den.aspects.sops.nixos = {
        imports = [inputs.sops-nix.nixosModules.sops];
        sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    };
    den.aspects.sops.homeManager = {pkgs, ...}: {
        home.packages = with pkgs; [
            sops
            ssh-to-age
            age
        ];
    };
}
