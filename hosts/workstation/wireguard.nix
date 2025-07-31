{config, ...}: {
    sops.secrets.wg-quick-wg0 = {
        sopsFile = ./wg0.conf;
        format = "binary";
        restartUnits = ["wg-quick-wg0.service"];
        neededForUsers = true;
    };
    networking = {
        firewall.allowedTCPPorts = [58394];
        wg-quick.interfaces.wg0.configFile = config.sops.secrets.wg-quick-wg0.path;
    };
    systemd.services.wg-quick-wg0.wantedBy = []; # prevent launching vp on boot
    environment.shellAliases = {
        vpn-start = "sudo systemctl start wg-quick-wg0";
        vpn-stop = "sudo systemctl stop wg-quick-wg0";
        vpn-status = "sudo systemctl status wg-quick-wg0";
    };
}
