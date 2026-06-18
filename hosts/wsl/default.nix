{
    den,
    inputs,
    config,
    ...
}: {
    flake-file.inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL";

    den.hosts.x86_64-linux.wsl.users.jesse = {};
    den.aspects.wsl = {
        includes = [den.aspects.dev];
        readme = {
            intro = ''
                # :warning: Disclaimer

                **I no longer use WSL and therefore can't guarrantee that this host works correctly.**
            '';
            install = ''
                Set up WSL from Windows (reboot Windows after the first step):

                1. **Install and update WSL**

                   ```powershell
                   wsl --install --no-distribution
                   wsl --update
                   ```

                2. **Import NixOS-WSL** — download the [latest installer](https://github.com/nix-community/NixOS-WSL)

                   ```powershell
                   wsl --import NixOS .\NixOS\ .\nixos-wsl.tar.gz --version 2
                   ```

                3. **Start a NixOS session**

                   ```powershell
                   wsl -d NixOS
                   ```

                Then clone this repo and rebuild:

                ${config.readmeLib.cloneRepo}

                ```bash
                sudo nixos-rebuild switch --flake .#wsl
                ```

                Finally restart WSL from Windows:

                ```powershell
                wsl --shutdown
                ```
            '';
        };
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
