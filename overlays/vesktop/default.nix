inputs: final: prev: {
    # thanks to https://github.com/joinemm/nix-infra/blob/b925365d8aa9eca01988660b2d0e7d5016e31d1b/modules/home/discord/default.nix#L25
    vesktop = inputs.nixpkgs-vesktop-pnpm-9.legacyPackages.${final.system}.vesktop.overrideAttrs (previousAttrs: {
        src = final.fetchFromGitHub {
            owner = "PolisanTheEasyNick";
            repo = "Vesktop";
            rev = "d15387257ce0c88ec848c8415f44b460d5590f9a";
            hash = "sha256-JowtPaz2kLjfv8ETgrrjiwn44T2WVPucrR1OoXV/cME=";
        };
        pnpmDeps = previousAttrs.pnpmDeps.overrideAttrs (_: {
            outputHash = "sha256-CHAA3RldLe1jte/701ckNELeiA4O1y2X3uMOhhuv7cc=";
        });
        patches = previousAttrs.patches ++ [./readonly-fix.patch];
        desktopItems = [
            (final.makeDesktopItem {
                name = "discord";
                desktopName = "Discord";
                exec = "vesktop %U";
                icon = "${final.discord}/share/icons/hicolor/256x256/apps/discord.png";
                startupWMClass = "Discord";
                genericName = "Internet Messenger";
                keywords = [
                    "discord"
                    "vencord"
                    "vesktop"
                ];
            })
        ];
    });
}
