{
    config,
    inputs,
    ...
}: {
    flake-file.inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL";

    flake.nixosConfigurations = config.flake.lib.mkNixos "x86_64-linux" "wsl";
    flake.modules.nixos.wsl = {pkgs, ...}: {
        system.stateVersion = "23.11";
        hm.home.stateVersion = "23.11";

        imports = [
            inputs.nixos-wsl.nixosModules.wsl

            config.flake.modules.nixos.dev
        ];

        wsl = {
            enable = true;
            wslConf = {
                automount.root = "/mnt";
                interop.appendWindowsPath = false;
                network.generateHosts = false;
                network.generateResolvConf = false; # business internet fix
            };
            defaultUser = "jesse";
            startMenuLaunchers = true;
        };

        networking.nameservers = ["8.8.4.4" "8.8.8.8"]; # business internet fix

        environment.shellAliases = {
            explorer = "/mnt/c/Windows/explorer.exe";
            docker = "/run/current-system/sw/bin/docker";
        };

        environment.systemPackages = [
            inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.win32yank
        ];
    };
}
