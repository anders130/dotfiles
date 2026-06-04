{
    flake.modules.nixos.nh = {
        programs.nh = {
            enable = true;
            flake = "/home/jesse/.dotfiles";
        };
    };
}
