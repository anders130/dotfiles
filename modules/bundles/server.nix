{
    config,
    username,
    ...
}: {
    security.pam.sshAgentAuth.enable = true;
    nix.settings.trusted-users = [username];
    services.openssh.enable = true;

    users.users.${username}.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN4fLfoAIHuVXS3tzzbw8x8P1N+Ju2uj3LmqCFs5eTiy ${username}@${config.networking.hostName}"
    ];

    # avoid password prompts when remote rebuilding
    security.sudo.extraRules = [
        {
            users = [username];
            commands = map (command: {
                inherit command;
                options = ["NOPASSWD"];
            }) [
                "/run/current-system/sw/bin/env"
                "/run/current-system/sw/bin/nix-env"
                "/run/current-system/sw/bin/systemd-run"
                "/etc/profiles/per-user/admin/bin/systemd-run"
            ];
        }
    ];
}
