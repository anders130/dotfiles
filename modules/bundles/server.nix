{
    config,
    lib,
    username,
    ...
}: {
    options.bundles.server = {
        enable = lib.mkEnableOption "server bundle";
    };

    config = lib.mkIf config.bundles.server.enable {
        security.pam.sshAgentAuth.enable = true;

        # this allows you to run `nixos-rebuild --target-host admin@this-machine` from
        # a different host. not used in this tutorial, but handy later.
        nix.settings.trusted-users = [username];

        services.openssh.enable = true;

        # avoid password prompts when remote rebuilding
        security.sudo.extraRules = [{
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
            ];
        }];
    };
}
