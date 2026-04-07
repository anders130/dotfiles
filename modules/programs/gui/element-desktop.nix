{
    config,
    lib,
    pkgs,
    ...
}: let
    c = config.lib.stylix.colors;
    mk = v: "#${v}";

    mkScale = prefix: color: let
        steps = [
            {n = "100"; v = mk c.base00;}
            {n = "200"; v = mk c.base00;}
            {n = "300"; v = mk c.base01;}
            {n = "400"; v = mk c.base02;}
            {n = "500"; v = mk c.base03;}
            {n = "600"; v = mk c.base04;}
            {n = "700"; v = mk c.base04;}
            {n = "800"; v = mk c.base04;}
            {n = "900"; v = mk color;}
            {n = "1000"; v = mk color;}
            {n = "1100"; v = mk color;}
            {n = "1200"; v = mk color;}
            {n = "1300"; v = mk color;}
            {n = "1400"; v = mk color;}
        ];
    in
        lib.listToAttrs (map (s: {
            name = "${prefix}-${s.n}";
            value = s.v;
        }) steps);

    grayScale = {
        "--cpd-color-gray-100" = mk c.base00;
        "--cpd-color-gray-200" = mk c.base00;
        "--cpd-color-gray-300" = mk c.base01;
        "--cpd-color-gray-400" = mk c.base02;
        "--cpd-color-gray-500" = mk c.base03;
        "--cpd-color-gray-600" = mk c.base04;
        "--cpd-color-gray-700" = mk c.base04;
        "--cpd-color-gray-800" = mk c.base04;
        "--cpd-color-gray-900" = mk c.base05;
        "--cpd-color-gray-1000" = mk c.base05;
        "--cpd-color-gray-1100" = mk c.base05;
        "--cpd-color-gray-1200" = mk c.base05;
        "--cpd-color-gray-1300" = mk c.base05;
        "--cpd-color-gray-1400" = mk c.base05;
    };

    customTheme = let
        isDark = config.stylix.polarity == "dark";
    in {
        name = "Stylix";
        is_dark = isDark;
        colors = {
            "accent-color" = mk c.base0D;
            "primary-color" = mk c.base0D;
            "warning-color" = mk c.base08;
            alert = mk c.base0A;
            "sidebar-color" = mk c.base00;
            "roomlist-background-color" = mk c.base00;
            "roomlist-text-color" = mk c.base05;
            "roomlist-text-secondary-color" = mk c.base04;
            "roomlist-highlights-color" = mk c.base03;
            "roomlist-separator-color" = mk c.base04;
            "timeline-background-color" = mk c.base01;
            "timeline-text-color" = mk c.base05;
            "secondary-content" = mk c.base05;
            "tertiary-content" = mk c.base05;
            "timeline-text-secondary-color" = mk c.base04;
            "timeline-highlights-color" = mk c.base00;
            "reaction-row-button-selected-bg-color" = mk c.base03;
            "menu-selected-color" = mk c.base03;
            "focus-bg-color" = mk c.base04;
            "room-highlight-color" = mk c.base0C;
            "togglesw-off-color" = mk c.base04;
            "other-user-pill-bg-color" = mk c.base0C;
            "username-colors" = [
                (mk c.base0E)
                (mk c.base08)
                (mk c.base09)
                (mk c.base0B)
                (mk c.base0C)
                (mk c.base0D)
                (mk c.base07)
                (mk c.base0F)
            ];
            "avatar-background-colors" = [
                (mk c.base0D)
                (mk c.base0E)
                (mk c.base0B)
            ];
        };
        compound =
            grayScale
            // (mkScale "--cpd-color-red" c.base08)
            // (mkScale "--cpd-color-orange" c.base09)
            // (mkScale "--cpd-color-yellow" c.base0A)
            // (mkScale "--cpd-color-lime" c.base0B)
            // (mkScale "--cpd-color-green" c.base0B)
            // (mkScale "--cpd-color-cyan" c.base0C)
            // (mkScale "--cpd-color-blue" c.base0D)
            // (mkScale "--cpd-color-purple" c.base0E)
            // (mkScale "--cpd-color-fuchsia" c.base0E)
            // (mkScale "--cpd-color-pink" c.base0F)
            // {
                "--cpd-color-theme-bg" = mk c.base01;

                "--cpd-color-text-primary" = mk c.base05;
                "--cpd-color-text-secondary" = mk c.base04;
                "--cpd-color-text-disabled" = mk c.base03;
                "--cpd-color-text-action-primary" = mk c.base05;
                "--cpd-color-text-action-accent" = mk c.base0D;
                "--cpd-color-text-link-external" = mk c.base0D;
                "--cpd-color-text-critical-primary" = mk c.base08;
                "--cpd-color-text-success-primary" = mk c.base0B;
                "--cpd-color-text-info-primary" = mk c.base0D;
                "--cpd-color-text-on-solid-primary" = mk c.base01;
                "--cpd-color-text-decorative-1" = mk c.base0B;
                "--cpd-color-text-decorative-2" = mk c.base0C;
                "--cpd-color-text-decorative-3" = mk c.base0F;
                "--cpd-color-text-decorative-4" = mk c.base0E;
                "--cpd-color-text-decorative-5" = mk c.base08;
                "--cpd-color-text-decorative-6" = mk c.base09;

                "--cpd-color-bg-subtle-primary" = mk c.base02;
                "--cpd-color-bg-subtle-secondary" = mk c.base01;
                "--cpd-color-bg-canvas-default" = mk c.base01;
                "--cpd-color-bg-canvas-default-level-1" = mk c.base00;
                "--cpd-color-bg-canvas-disabled" = mk c.base00;
                "--cpd-color-bg-subtle-secondary-level-0" = mk c.base00;
                "--cpd-color-bg-action-primary-disabled" = mk c.base03;
                "--cpd-color-bg-action-secondary-rest" = mk c.base01;
                "--cpd-color-bg-action-tertiary-rest" = mk c.base01;
                "--cpd-color-bg-action-tertiary-hovered" = mk c.base02;
                "--cpd-color-bg-action-tertiary-selected" = mk c.base03;
                "--cpd-color-bg-critical-primary" = mk c.base08;
                "--cpd-color-bg-critical-hovered" = mk c.base08;
                "--cpd-color-bg-critical-subtle" = mk c.base02;
                "--cpd-color-bg-success-subtle" = mk c.base02;
                "--cpd-color-bg-info-subtle" = mk c.base02;
                "--cpd-color-bg-accent-rest" = mk c.base0D;
                "--cpd-color-bg-accent-hovered" = mk c.base0D;
                "--cpd-color-bg-accent-pressed" = mk c.base0D;
                "--cpd-color-bg-accent-selected" = mk c.base02;
                "--cpd-color-bg-decorative-1" = mk c.base02;
                "--cpd-color-bg-decorative-2" = mk c.base02;
                "--cpd-color-bg-decorative-3" = mk c.base02;
                "--cpd-color-bg-decorative-4" = mk c.base02;
                "--cpd-color-bg-decorative-5" = mk c.base02;
                "--cpd-color-bg-decorative-6" = mk c.base02;

                "--cpd-color-icon-primary" = mk c.base05;
                "--cpd-color-icon-secondary" = mk c.base04;
                "--cpd-color-icon-tertiary" = mk c.base03;
                "--cpd-color-icon-quaternary" = mk c.base03;
                "--cpd-color-icon-accent-primary" = mk c.base0D;
                "--cpd-color-icon-critical-primary" = mk c.base08;
                "--cpd-color-icon-success-primary" = mk c.base0B;
                "--cpd-color-icon-info-primary" = mk c.base0D;
                "--cpd-color-icon-on-solid-primary" = mk c.base01;
                "--cpd-color-icon-disabled" = mk c.base03;

                "--cpd-color-border-interactive-primary" = mk c.base04;
                "--cpd-color-border-interactive-secondary" = mk c.base03;
                "--cpd-color-border-interactive-hovered" = mk c.base05;
                "--cpd-color-border-disabled" = mk c.base03;
                "--cpd-color-border-focused" = mk c.base0D;
                "--cpd-color-border-critical-primary" = mk c.base08;
                "--cpd-color-border-success-subtle" = mk c.base03;
                "--cpd-color-border-info-subtle" = mk c.base03;
                "--cpd-color-border-accent-subtle" = mk c.base03;
            };
    };

    customThemeFile = pkgs.writeText "element.json" (builtins.toJSON customTheme);
    importedTheme = lib.importJSON customThemeFile;
in {
    hm.programs.element-desktop = {
        enable = true;
        settings = {
            default_theme = importedTheme.name;
            setting_defaults.custom_themes = [importedTheme];
        };
    };
}
