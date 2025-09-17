# Space Engineers

This module provides a Space Engineers instance running on a Docker container from the [devidian/spaceengineers](https://hub.docker.com/r/devidian/spaceengineers) image.

## Usage

1. Add the module to your `configuration.nix`:

   ```nix
   {
       services.space-engineers = {
           enable = true;
           port = 27016;
           instanceName = "default";
           dataDir = "/var/lib/space-engineers";
       };
   }
   ```

2. Set up the instance:
   1. Setup a SE instance like explained [here](https://www.spaceengineersgame.com/dedicated-servers/)
   2. Rename the `<LoadWorld>` value in the `SpaceEngineers-Dedicated.cfg` file to:

      ```xml
      <MyConfigDedicated>
          ...
          <LoadWorld>Z:\appdata\space-engineers\instances\default\Saves\[World Name]</LoadWorld>
          <WorldName>[World Name]</WorldName>
          ...
      </MyConfigDedicated>
      ```

   3. Copy the instance into the `instances` directory:
      > the Instance is located in `C:\Users\[User]\AppData\Roaming\SpaceEngineersDedicated`

3. Start the service:

   ```sh
   sudo systemctl start podman-space-engineers
   ```
