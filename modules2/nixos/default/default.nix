{pkgs}: {
    environment.systemPackages = with pkgs; [
        # useful for sops
        sops
        ssh-to-age
        age
    ];
}
