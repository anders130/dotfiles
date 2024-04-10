{
    username,
    firefoxProfiles,
    home-symlink,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
        home.file.".mozilla/firefox/${builtins.elemAt firefoxProfiles 0}/chrome" = home-symlink {
            config = config;
            source = "firefox/chrome";
            recursive = true;
        };

        home.file.".mozilla/firefox/${builtins.elemAt firefoxProfiles 1}/chrome" = home-symlink {
            config = config;
            source = "firefox/chrome";
            recursive = true;
        };
    };
}
