{
    den,
    lib,
    config,
    ...
}: let
    sectionType = config.readmeLib.mkSectionType lib;
in {
    den = {
        classes.readme.description = "Per-host README content, collected from the aspects a host includes.";

        default = {
            includes = [den.policies.readme-to-host];
            nixos = {lib, ...}: {
                options.readme = lib.mkOption {
                    internal = true;
                    visible = false;
                    default = {};
                    type = lib.types.submodule {
                        options = {
                            intro = lib.mkOption {
                                type = lib.types.lines;
                                default = "";
                            };
                            install = lib.mkOption {
                                type = lib.types.lines;
                                default = "";
                            };
                            preInstall = lib.mkOption {
                                type = lib.types.listOf sectionType;
                                default = [];
                                description = "Steps rendered before the install command.";
                            };
                            sections = lib.mkOption {
                                type = lib.types.listOf sectionType;
                                default = [];
                            };
                        };
                    };
                };
            };
        };
        policies.readme-to-host = {host, ...}:
            lib.optional
            (host ? class && builtins.elem host.class ["nixos" "darwin"])
            (den.lib.policy.route {
                fromClass = "readme";
                intoClass = host.class;
                path = ["readme"];
            });
    };
}
