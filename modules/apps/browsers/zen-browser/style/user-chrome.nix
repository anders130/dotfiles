{
    dots.apps.provides.zen-browser.homeManager = {
        config,
        lib,
        ...
    }: {
        programs.zen-browser.profiles = lib.genAttrs (builtins.attrNames config.my.zen.profiles) (_: {
            userChrome = with config.lib.stylix.colors;
            #css
                ''
                    /* clarify unloaded tabs */
                    .tabbrowser-tab[pending="true"] {
                      opacity: 0.5 !important;
                    }

                    /* transparent browser */
                    #zen-browser-background {
                      opacity: 0.8 !important;
                    }
                    .browser-toolbox-background {
                      background: transparent !important;
                    }

                    /* hide titlebar buttons */
                    .titlebar-close {
                      display: none !important;
                    }

                    /* urlbar */
                    .urlbar-input-container {
                      background-color: #${base02-hex} !important;
                      opacity: 0.8 !important;
                    }

                    /* active tab text: zen renamed --tab-selected-textcolor to --tab-text-color-selected */
                    .tabbrowser-tab[selected] {
                      --tab-text-color-selected: #${base05-hex} !important;
                    }

                    /* zen-theme.css outranks a plain :root override of these in unsynced/private windows */
                    :root[zen-unsynced-window='true'],
                    :root[zen-private-window='true'] {
                      --zen-primary-color: #${base0D-hex} !important;
                      --toolbox-textcolor: #${base05-hex} !important;
                    }

                    /* new tab button text + icon fill (excluded from the normal .toolbarbutton-1 rule) */
                    #tabs-newtab-button,
                    #vertical-tabs-newtab-button {
                      color: #${base05-hex} !important;
                      --toolbarbutton-icon-fill: #${base05-hex} !important;
                    }
                '';
        });
    };
}
