# WinApps

## Installation

```nix
modules.programs.gui.winapps.enable = true;
```

Start the windows VM with:

```bash
systemctl start WinApps
```

Open the noVNC web interface at [http://localhost:8006](http://localhost:8006)
There, wait for the download to finish and windows to install. This may take a while.

Then you can setup the `.desktop` files that winapps will create for you:

```bash
winapps-setup
```

1. Select `Install`
2. Select `System`
3. Select `Automatic`
