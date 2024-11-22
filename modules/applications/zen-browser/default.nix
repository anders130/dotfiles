{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: lib.mkModule config ./. {
    imports = [
        inputs.nur.nixosModules.nur
    ];
    config = {
        environment.systemPackages = [inputs.zen-browser.packages.${pkgs.system}.specific];
        home-manager.users.${username} = {
            programs.firefox.profiles.zen-browser = {
                isDefault = false;
                id = 100;
                path = "../../.zen/default";
                userChrome = builtins.readFile ./userChrome.css;
                userContent = builtins.readFile ./userContent.css;
                extensions = with config.nur.repos.rycee.firefox-addons; [
                    bitwarden
                    darkreader
                    github-file-icons
                    istilldontcareaboutcookies
                    return-youtube-dislikes
                    stylus
                    ublock-origin
                    video-downloadhelper
                    vimium-c
                    wappalyzer
                ];

                settings."app.update.checkInstallTime" = false; # disable update notifications
            };

            home.file.".zen/profiles.ini".text = /*ini*/''
                [Profile0]
                Name=default
                IsRelative=1
                Path=default
                ZenAvatarPath=chrome://browser/content/zen-avatars/avatar-55.svg
                Default=1

                [General]
                StartWithLastProfile=1
                Version=2
            '';
        };
    };
}
