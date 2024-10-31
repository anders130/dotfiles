{
    config,
    lib,
    pkgs,
    ...
}: let
    cfg = config.modules.programs.ssh;

    sshKeyFix = pkgs.writeShellScriptBin "ssh-key-fix" ''
        # fix ssh agent
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
    options.modules.programs.ssh = {
        enable = lib.mkEnableOption "ssh";
    };

    config = lib.mkIf cfg.enable {
        environment.systemPackages = [
            sshKeyFix
        ];

        services.openssh.enable = true;
        programs.ssh.startAgent = true;
    };
}
