{
    config,
    username,
    ...
}: {
    security.pam.sshAgentAuth.enable = true;

    # this allows you to run `nixos-rebuild --target-host admin@this-machine` from
    # a different host. not used in this tutorial, but handy later.
    nix.settings.trusted-users = [username];

    users.users.${username}.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfImZ8A0bd2+tCbcikQr9H2R5j7rmov/Wp5Sa8soQqi ${username}@${config.networking.hostName}"
    ];

    services.openssh.enable = true;

    # avoid password prompts when remote rebuilding
    security.sudo.extraRules = [
        {
            users = [username];
            commands = [
                {
                    command = "/run/current-system/sw/bin/env";
                    options = ["NOPASSWD"];
                }
                {
                    command = "/run/current-system/sw/bin/nix-env";
                    options = ["NOPASSWD"];
                }
                {
                    command = "/run/current-system/sw/bin/systemd-run";
                    options = ["NOPASSWD"];
                }
                {
                    command = "/etc/profiles/per-user/admin/bin/systemd-run";
                    options = ["NOPASSWD"];
                }
            ];
        }
    ];
}
