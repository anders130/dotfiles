{
    den.aspects.displaylink = {
        nixos = {
            config,
            lib,
            pkgs,
            ...
        }: {
            boot.extraModulePackages = with config.boot.kernelPackages; [evdi];
            services.xserver = {
                videoDrivers = ["displaylink" "modesetting"];
                displayManager.sessionCommands = ''
                    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
                '';
            };
        };
        readme = {
            pkgs,
            lib,
            ...
        }: let
            inherit (lib) findFirst hasInfix last splitString trim;
            url =
                pkgs.displaylink.src.drvAttrs.args
                |> last
                |> builtins.readFile
                |> splitString "\n"
                |> findFirst (l: hasInfix "prefetch-url --name" l && hasInfix "https://" l) ""
                |> trim
                |> splitString " "
                |> last;
        in {
            preInstall = [
                {
                    title = "DisplayLink driver";
                    content = ''
                        This configuration enables the DisplayLink module. The driver is unfree and must be fetched into the store before installing:

                        ```bash
                        nix-prefetch-url --name ${pkgs.displaylink.src.name} ${url}
                        ```
                    '';
                }
            ];
        };
    };
}
