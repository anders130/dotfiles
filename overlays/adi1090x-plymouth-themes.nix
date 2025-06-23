_: final: prev: {
    adi1090x-plymouth-themes = prev.adi1090x-plymouth-themes.overrideAttrs (previousAttrs: {
        installPhase =
            previousAttrs.installPhase
            + ''
                find $out/share/plymouth/themes/ -name \*.script -exec sed -i 's/Window.GetX()/Window.GetX(0)/g' {} \;
                find $out/share/plymouth/themes/ -name \*.script -exec sed -i 's/Window.GetY()/Window.GetY(0)/g' {} \;
            '';
    });
}
