{den, ...}: {
    den.default.includes = with den.aspects; [
        den.batteries.define-user
        den.batteries.hostname
        den.batteries.self'
        den.batteries.inputs'
        sops
        ssh
        nix
        nh
        nvix
        fish
        cli
        nix-index
        btop
    ];
}
