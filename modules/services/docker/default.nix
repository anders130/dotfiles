{username, ...}: {
    virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune.enable = true;
    };

    users.users.${username}.extraGroups = ["docker"];
}
