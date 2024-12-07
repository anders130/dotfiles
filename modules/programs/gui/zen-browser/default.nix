{
    config,
    inputs,
    lib,
    ...
}: {
    imports = [inputs.nur.nixosModules.nur];

    environment.systemPackages = [(lib.getPkgs "zen-browser").specific];

    hm = {
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
            ".zen/default/chrome/userChrome.css" = lib.mkSymlink ./userChrome.css;
            ".zen/default/chrome/userContent.css" = lib.mkSymlink ./userContent.css;
        };
    };
}
