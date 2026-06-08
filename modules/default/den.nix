{
    den,
    dots,
    ...
}: {
    den.default.includes =
        (with den.aspects; [
            den.batteries.define-user
            den.batteries.hostname
            den.batteries.self'
            den.batteries.inputs'
            sops
            ssh
            nix
            fish
            nix-index
            btop
        ])
        ++ [dots.shell.provides.nvix];
}
