{
    den,
    inputs,
    ...
}: {
    flake-file.inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL";

    den.hosts.x86_64-linux.wsl.users.jesse = {};
    den.aspects.wsl = {
        includes = [den.aspects.dev];
        nixos = {self', ...}: {
            system.stateVersion = "23.11";

            imports = [
                inputs.nixos-wsl.nixosModules.wsl
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
                self'.packages.win32yank
            ];
        };
    };
}
