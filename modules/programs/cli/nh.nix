{flakePath, ...}: {
    programs.nh = {
        enable = true;
        flake = flakePath;
    };
}
