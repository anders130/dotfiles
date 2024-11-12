{
    config,
    lib,
    pkgs,
    ...
}: lib.mkModule config ./kanata.nix {
    services.kanata = {
        enable = true;
        package = pkgs.kanata;
        keyboards.default.config = ''
            (defsrc
                caps
                lalt ralt
                lsft rsft
                a o u s e
            )
            (deflayer default
                esc
                @alt @alt
                lsft rsft
                a o u s e
            )
            (deflayer unicodechars
                esc
                lalt ralt
                lsft rsft
                @ae @oe @ue @sz @eu
            )
            (defalias
                _ae (unicode ä)
                _Ae (unicode Ä)
                _oe (unicode ö)
                _Oe (unicode Ö)
                _ue (unicode ü)
                _Ue (unicode Ü)
                _sz (unicode ß)
                _Sz (unicode ẞ)

                ae (fork @_ae @_Ae (lsft rsft))
                oe (fork @_oe @_Oe (lsft rsft))
                ue (fork @_ue @_Ue (lsft rsft))
                sz (fork @_sz @_Sz (lsft rsft))
                eu (unicode €)

                alt (tap-hold 150 150 alt (layer-while-held unicodechars))
            )
        '';
    };
}
