{
    config,
    flakePath,
    lib,
    pkgs,
    username,
    ...
}: let
    containerBackend = "docker";
    windowsDir = "/var/lib/windows";
in {
    environment.systemPackages = with pkgs; [
        winapps
        winapps-launcher
        freerdp
    ];
    virtualisation.oci-containers = {
        backend = containerBackend;
        containers = {
            # https://github.com/winapps-org/winapps
            "WinApps" = {
                serviceName = "WinApps";
                image = "ghcr.io/dockur/windows:latest";
                environment = {
                    "VERSION" = "11";
                    "RAM_SIZE" = "4G";
                    "CPU_CORES" = "4";
                    "DISK_SIZE" = "64G";
                    "USERNAME" = username;
                    "HOME" = "/home/${username}";
                };
                environmentFiles = [config.sops.templates."winapps.env".path];
                ports = [
                    "8006:8006"
                    "3389:3389/tcp"
                    "3389:3389/udp"
                ];
                extraOptions = [
                    "--cap-add=NET_ADMIN"
                    "--cap-add=CAP_NET_RAW"
                    "--sysctl=net.ipv4.ip_forward=1"
                ];
                volumes = [
                    "${windowsDir}:/storage"
                    "/home/${username}:/shared"
                    "${flakePath}/${lib.mkRelativePath ./oem}:/oem"
                ];
                devices = [
                    "/dev/kvm"
                    "/dev/net/tun"
                ];
                autoStart = false;
            };
        };
    };
    systemd.tmpfiles.rules = [
        "d ${windowsDir} 0755 root root - -"
    ];
    users.users.${username}.extraGroups = [containerBackend];
    sops = {
        secrets.windows-password.sopsFile = ./secrets.yaml;
        templates = {
            "winapps.env".content = "PASSWORD=${config.sops.placeholder.windows-password}";
            "winapps.conf" = {
                path = "/home/${username}/.config/winapps/winapps.conf";
                content = ''
                    RDP_USER="${username}"
                    RDP_PASS="${config.sops.placeholder.windows-password}"
                    WAFLAVOR="${containerBackend}"
                    RDP_SCALE="100"
                    REMOVABLE_MEDIA="/run/media"
                    RDP_IP="127.0.0.1"
                    VM_NAME="RDPWindows"
                    RDP_FLAGS="/cert:tofu /sound /microphone +home-drive"
                    PORT_TIMEOUT="5"
                    RDP_TIMEOUT="30"
                    APP_SCAN_TIMEOUT="60"
                    BOOT_TIMEOUT="120"
                '';
                owner = username;
                group = containerBackend;
            };
        };
    };
}
