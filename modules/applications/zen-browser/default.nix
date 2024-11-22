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
        home-manager.users.${username} = hm: {
            programs.firefox.profiles.zen-browser = {
                isDefault = false;
                id = 100;
                path = "../../.zen/default";
                extensions = with config.nur.repos.rycee.firefox-addons; [
                    bitwarden
                    darkreader
                    github-file-icons
                    istilldontcareaboutcookies
                    return-youtube-dislikes
                    stylus
                    ublock-origin
                    video-downloadhelper
                    vimium
                    wappalyzer
                ];

                settings."app.update.checkInstallTime" = false; # disable update notifications
            };

            home.file = {
                ".zen/profiles.ini".text = /*ini*/''
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
                ".zen/default/chrome/userChrome.css" = lib.mkSymlink hm.config ./userChrome.css;
                ".zen/default/chrome/userContent.css" = lib.mkSymlink hm.config ./userContent.css;
            };
        };
    };
}
