{den, ...}: {
    den.aspects.jesse = {
        includes = [den.batteries.primary-user];
        homeManager = {
            home.keyboard = {
                layout = "us";
                variant = "de_se_fi";
                options = ["caps:escape"];
            };
        };
    };
}
