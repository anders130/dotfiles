{
    flake-file.inputs.clock-mate.url = "github:clock-mate/extension";
    den.aspects.zen-browser.homeManager = {inputs', ...}: {
        programs.zen-browser.profiles.work = {
            id = 1;
            isDefault = false;
            extensions.packages = [inputs'.clock-mate.packages.default];
        };
    };
}
