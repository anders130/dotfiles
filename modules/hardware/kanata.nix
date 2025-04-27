{pkgs, ...}: {
    services.kanata = {
        enable = true;
        package = pkgs.kanata;
        keyboards.default.config = ''
            (defsrc
                caps
            )
            (deflayer default
                esc
            )
        '';
    };
}
