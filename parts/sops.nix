{inputs, ...}: {
    flake-file.inputs.sops-nix.url = "github:Mic92/sops-nix";
    flake.modules.nixos.sops = {
        imports = [inputs.sops-nix.nixosModules.sops];
        sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    };
    flake.modules.homeManager.sops = {pkgs, ...}: {
        home.packages = with pkgs; [
            sops
            ssh-to-age
            age
        ];
    };
}
