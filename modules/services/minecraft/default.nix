{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: let
    inherit (builtins) attrNames attrValues elem filter isList listToAttrs mapAttrs readDir replaceStrings;
    inherit (lib) flatten genAttrs mkEnableOption mkMerge mkOption optional optionalAttrs types unique;
    mkEnabledOption = description:
        mkOption {
            inherit description;
            type = types.bool;
            default = true;
        };
in {
    imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
    options = {
        dataDir = mkOption {
            type = types.str;
            default = "/srv/minecraft";
            description = "Directory to store Minecraft data in";
        };
        friends = mkOption {
            type = types.attrsOf types.str;
            description = "List of Minecraft friends, who will be able to join your server if the option `onlyFriends` is set to `true`.";
        };
        servers = mkOption {
            type = types.attrsOf (
                types.submodule {
                    options = {
                        enable = mkEnabledOption "Enable the server";
                        server-port = mkOption {
                            type = types.port;
                            default = 25566;
                        };
                        openFirewall = mkEnabledOption "Open firewall for server-port";
                        motd = mkOption {
                            type = types.str;
                            default = "This is a Minecraft Server";
                        };
                        server-icon = mkOption {
                            type = types.nullOr types.path;
                            default = ./server-icon.png;
                        };
                        rcon = {
                            enable = mkEnableOption "Enable RCON";
                            port = mkOption {
                                type = types.port;
                                default = 25575;
                            };
                            openFirewall = mkEnabledOption "Open firewall for RCON port";
                        };
                        autoStart = mkEnableOption "Automatically start the server";
                        onlyFriends = mkEnableOption "Only allow friends to join the server";
                        type = mkOption {
                            type = types.enum ["vanilla" "fabric"];
                            default = "vanilla";
                        };
                        version = mkOption {
                            type = types.str;
                            default = "1.21.10";
                        };
                        mods = mkOption {
                            type = types.oneOf [(types.listOf types.package) types.path];
                            default = [];
                            description = "List of mods to install. Can be a list of packages or a path to .nix file containing the list of packages.";
                        };
                        ignoredMods = mkOption {
                            type = types.listOf types.str;
                            default = [];
                            description = "List of mod names to ignore when generating symlinks. Useful if the modpack contains a mod with the same name as a mod in the mods list, but you only want to symlink one of them.";
                        };
                        modpack = mkOption {
                            type = types.nullOr types.package;
                            default = null;
                        };
                        serverProperties = mkOption {
                            type = types.attrs;
                            default = {};
                        };
                        ram = mkOption {
                            type = types.str;
                            default = "4G";
                            description = "Amount of RAM to allocate to the server";
                        };
                        symlinks = mkOption {
                            type = types.attrsOf types.path;
                            default = {};
                        };
                        files = mkOption {
                            type = types.attrsOf types.path;
                            default = {};
                        };
                    };
                }
            );
        };
    };
    config = cfg: {
        services.minecraft-servers = {
            inherit (cfg) dataDir;
            enable = true;
            eula = true;
            environmentFile = config.sops.secrets.minecraft.path;
            servers = mapAttrs (n: v: let
                getPackage = {
                    version,
                    type,
                    ...
                }:
                    pkgs.minecraftServers."${type}-${replaceStrings ["."] ["_"] version}";

                default = {
                    enable = true;
                    inherit (v) autoStart symlinks files;
                    serverProperties = mkMerge [
                        {
                            inherit (v) server-port motd;
                            server-ip = "0.0.0.0";
                        }
                        v.serverProperties
                    ];
                    jvmOpts = ["-Xmx${v.ram}" "-Xms${v.ram}"];
                };
                withRcon = {
                    serverProperties = {
                        enable-rcon = true;
                        "rcon.password" = "@RCON_PASS@";
                        "rcon.port" = v.rcon.port;
                    };
                };
                onlyFriends = {
                    serverProperties = {
                        white-list = true;
                        enforce-whitelist = true;
                    };
                    whitelist = cfg.friends;
                };
                mkModsSymlinks = {
                    mods,
                    ignoredMods,
                    modpack,
                    ...
                }: let
                    baseMods =
                        (
                            if mods == [] || mods == null
                            then []
                            else if isList mods
                            then mods
                            else import mods pkgs
                        )
                        |> map (mod: {
                            name = "mods/${mod.name}";
                            value = mod;
                        });
                    modpackMods =
                        if modpack == null
                        then []
                        else
                            "${modpack}/mods"
                            |> readDir
                            |> attrNames
                            |> map (name: {
                                name = "mods/${baseNameOf (toString name)}";
                                value = "${modpack}/mods/${name}";
                            });
                in
                    baseMods
                    ++ modpackMods
                    |> filter (mod: !(elem mod.name ignoredMods))
                    |> listToAttrs;
            in
                mkMerge [
                    default
                    {package = getPackage v;}
                    (optionalAttrs v.rcon.enable withRcon)
                    (optionalAttrs v.onlyFriends onlyFriends)
                    (optionalAttrs (v.server-icon != null) {
                        symlinks."server-icon.png" = v.server-icon;
                    })
                    (optionalAttrs (v.mods != [] || v.modpack != null) {
                        symlinks = mkModsSymlinks v;
                    })
                    (optionalAttrs (v.modpack != null && v.server-icon == null) {
                        symlinks = genAttrs [
                            "server-icon.png"
                        ] (name: "${v.modpack}/${name}");
                    })
                ])
            cfg.servers;
        };

        sops.secrets.minecraft = {
            sopsFile = ./secrets.env;
            format = "dotenv";
            owner = "minecraft";
            group = "minecraft";
        };

        networking.firewall.allowedTCPPorts =
            cfg.servers
            |> attrValues
            |> map (s:
                optional s.openFirewall s.server-port
                ++ optional s.rcon.openFirewall s.rcon.port)
            |> flatten
            |> unique;
    };
}
