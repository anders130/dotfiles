{
    dots.apps.provides.loupe.homeManager = {pkgs, ...}: {
        home.packages = [pkgs.loupe];
    };
}
