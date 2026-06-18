{inputs, ...}: {
    flake-file.inputs.lanzaboote.url = "github:nix-community/lanzaboote";
    den.aspects.lanzaboote = {
        nixos.imports = [inputs.lanzaboote.nixosModules.lanzaboote];
        readme.sections = [
            {
                title = "Setup Secure-Boot";
                content = ''
                    Set a **BIOS password** and disable **key protection** in the BIOS (usually `F2` during boot).

                    1. **Create secure boot keys**

                       ```bash
                       sudo nix run nixpkgs#sbctl create-keys
                       sudo nix run nixpkgs#sbctl verify
                       ```

                    2. **Enable Secure-Boot in the BIOS** — enable **Secure-Boot** and check **clear keys on next boot**, then restart.

                    3. **Enroll Secure-Boot keys**

                       ```bash
                       sudo nix run nixpkgs#sbctl enroll-keys -- --microsoft
                       ```

                    4. **Verify** after a reboot

                       ```bash
                       bootctl status
                       ```
                '';
            }
        ];
    };
}
