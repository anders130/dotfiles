{
    dots.apps.provides.decibels.homeManager = {pkgs, ...}: {
        home.packages = [pkgs.decibels];
        home.shellAliases.decibels = "org.gnome.Decibels";
    };
}
