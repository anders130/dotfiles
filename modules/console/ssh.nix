{pkgs, ...}: let
    sshAddAllKeys = pkgs.writeShellScriptBin "ssh-add-all-keys" ''
        if ssh-add -l | grep -q "The agent has no identities."; then
            for key in ~/.ssh/id_*; do
                if [[ -f $key && ! $key =~ \.pub$ ]]; then
                    ssh-add "$key"
                fi
            done
        else
            echo "SSH agent already has identities loaded."
        fi
    '';
in {
    services.openssh.enable = true;
    programs.ssh.startAgent = true;

    environment.systemPackages = [
        sshAddAllKeys
    ];
}
