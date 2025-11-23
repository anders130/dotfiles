{
    config,
    lib,
    pkgs,
    username,
    ...
}: let
    servicePath = "/var/lib/quickemu";
    sharePath = "/home/${username}/public";
    novncPort = 6080;
    vmPath = "${servicePath}/windows-11-23h2";
    files = {
        windows-iso = {
            path = "${vmPath}/windows.iso";
            url = "https://dn721608.ca.archive.org/0/items/win11_23h2_english_x64v2_202409/Win11_23H2_English_x64v2.iso";
        };
        virtio-win = {
            path = "${vmPath}/virtio-win.iso";
            url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso";
        };
    };
    windows-11-conf = pkgs.writeText "windows-11-23h2.conf" ''
        #! --vm
        guest_os="windows"
        disk_img="${vmPath}/disk.qcow2"
        iso_img="${vmPath}/windows.iso"
        fixed_iso="${vmPath}/virtio-win.iso"
        disk_size="64G"
        tpm="on"
        secureboot="off"
    '';
    setupVmScript = pkgs.writeShellScriptBin "setup-vm" ''
        mkdir -p ${vmPath}
        # Windows ISO
        if [ ! -e "${files.windows-iso.path}" ]; then
            ${lib.getExe pkgs.wget} -O ${files.windows-iso.path} ${files.windows-iso.url}
        fi
        # Virtio ISO
        if [ ! -e "${files.virtio-win.path}" ]; then
            ${lib.getExe pkgs.wget} -O ${files.virtio-win.path} ${files.virtio-win.url}
        fi
    '';
    startVmScript = pkgs.writeShellScriptBin "start-vm" ''
        ${lib.getExe pkgs.quickemu} \
          --vm ${windows-11-conf} \
          --display none \
          --extra_args "-vnc :1"
    '';
    stopVmScript = pkgs.writeShellScriptBin "stop-vm" ''
        # Kill QEMU processes related to this VM (adjust if needed)
        pkill -f "${vmPath}/disk.qcow2"
    '';
in {
    systemd.tmpfiles.rules = [
        # Create the Quickemu VM directory
        "d ${servicePath} 0755 root root - -"
        # Ensure the samba Public share exists
        "d ${sharePath} 0755 ${username} users - -"
    ];
    environment.systemPackages = [
        setupVmScript
        startVmScript
        stopVmScript
    ];
    # novnc with caddy
    systemd.services.novnc-windows11 = {
        description = "novnc for headless windows11 vm";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
            ExecStart = ''
                ${lib.getExe pkgs.novnc} \
                    --vnc localhost:5901 \
                    --listen ${toString novncPort}
            '';
            Environment = "PATH=${pkgs.procps}/bin:${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin";
            Restart = "always";
        };
    };
    modules.services.caddy.virtualHosts."http://windows11.qemu.${config.networking.hostName}" = {
        local = true;
        extraConfig = ''
            handle /websockify* {
                reverse_proxy localhost:${toString novncPort}
            }

            root * ${pkgs.novnc}/share/webapps/novnc
            file_server

            handle_path / {
                rewrite * /vnc.html
            }
        '';
    };
    # fileshare with samba
    services.samba = {
        enable = true;
        openFirewall = false; # only local network for vm
        settings = let
            mkFileShare = path: {
                inherit path;
                browseable = "yes";
                "read only" = "no";
                "guest ok" = "yes";
                "create mask" = "0644";
                "directory mask" = "0755";
                "force user" = username;
                "force group" = "users";
            };
        in {
            global = {
                "workgroup" = "WORKGROUP";
                "server string" = "smbnix";
                "netbios name" = "smbnix";
                "security" = "user";
                "hosts allow" = "192.168.178. 127.0.0.1 localhost";
                "hosts deny" = "0.0.0.0/0";
                "guest account" = "nobody";
                "map to guest" = "bad user";
            };
            data = mkFileShare "/mnt/rackflix/data/downloads";
            appdata = mkFileShare "/mnt/rackflix/appdata/downloads";
        };
    };
}
