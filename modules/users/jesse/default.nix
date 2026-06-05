{den, ...}: {
    den.aspects.jesse = {
        # admin user: adds wheel + networkmanager groups
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
