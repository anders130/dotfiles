{
    inputs,
    lib,
    username,
}: [
    (lib.modules.mkAliasOptionModule ["hm"] ["home-manager" "users" username])
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix
]
