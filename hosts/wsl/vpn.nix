{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        wsl-vpnkit
    ];

    environment.shellAliases = {
        vpn-start = "sudo systemctl start wsl-vpnkit";
        vpn-stop = "sudo systemctl stop wsl-vpnkit";
        vpn-status = "systemctl status wsl-vpnkit";
    };
    systemd.services.wsl-vpnkit = {
        enable = true;
        description = "wsl-vpnkit";
        serviceConfig = {
            ExecStart = "${pkgs.wsl-vpnkit}/bin/wsl-vpnkit";
            Type = "idle";
            Restart = "always";
            KillMde = "mixed";
        };
    };
}
