{config, ...}: {
    sops.secrets.easyroam = {
        sopsFile = ./easyroam-secret;
        format = "binary";
        restartUnits = ["easyroam-install.service"];
    };
    services.easyroam = {
        enable = true;
        pkcsFile = config.sops.secrets.easyroam.path;
        networkmanager.enable = true;
    };
}
