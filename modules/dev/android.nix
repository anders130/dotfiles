{
    den.aspects.android = {
        nixos = {config, ...}: {
            users.groups.kvm.members = config.users.normalUsers;
        };
        homeManager = {pkgs, ...}: {
            home.packages = [pkgs.android-studio];
            my.desktop.windowRules.android-emulator = {
                match = "Emulator";
                float = true;
                opacity = "opaque";
            };
        };
    };
}
