# Keil uVision

To make this package work, you need to follow the following steps:

1. Download the installer from [Keil](https://developer.arm.com/Tools%20and%20Software/Keil%20PK51)

2. Run the installer with wine

   ```bash
   mkdir /tmp/wine-keil
   WINEPREFIX=/tmp/wine-keil nix run nixpkgs#wine -- C51V961.EXE
   ```

3. Then run the program for the first time to populate the registry

   ```bash
   WINEPREFIX=/tmp/wine-keil nix run nixpkgs#wine -- $WINEPREFIX/drive_c/Keil_v5/UV4/UV4.exe
   ```

4. Make a Tarball of the installation files

   ```bash
   cd /tmp/wine-keil/drive_c/ && tar cvJf /tmp/keil-uvision-c51-9.61-preinstalled.tar.xz ./Keil_v5
   ```

5. Rebuild the system with this package added to the `environment.systemPackages`

   If you encounter any issues, you can try to update the hash of the tarball by running

   ```bash
   nix-hash --type sha256 --flat /tmp/keil-uvision-c51-9.61-preinstalled.tar.xz
   ```

   And then copy the hash to the `sha256` field in the `default.nix` file.

If you have multiple desktop entries, you can just delete the wine ones:

```bash
rm -rf ~/.local/share/applications/wine
```

Special thanks to [bjornfor](https://github.com/bjornfor) for the initial work on this package.
