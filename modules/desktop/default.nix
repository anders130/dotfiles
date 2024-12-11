args @ {lib, ...}: let
    # recursiveMerge = lib.fix (merge: sets:
    #     lib.foldl' (acc: set:
    #         acc
    #         // lib.mapAttrs (k: v:
    #             if lib.isAttrs v && lib.hasAttr k acc
    #             then merge [acc.${k} v]
    #             else v)
    #         set) {}
    #     sets);
    recursiveMerge = sets: lib.foldl' (acc: set: lib.attrsets.recursiveUpdate acc set) {} sets;
    # in (lib.recursiveUpdate
in (recursiveMerge [
    (import ./monitors.nix args)
    (import ./test.nix args)
    {
        options = {
            monitors = lib.mkOption {
                type = lib.types.attrsOf (
                    lib.types.submodule {
                        options = {
                            isMain = lib.mkOption {
                                type = lib.types.bool;
                                default = false;
                                description = "Whether this is the main monitor";
                            };
                            port = lib.mkOption {
                                type = lib.types.str;
                                description = "Monitor port";
                            };
                            resolution = lib.mkOption {
                                type = lib.types.str;
                                description = "Monitor resolution";
                            };
                            refreshRate = lib.mkOption {
                                type = lib.types.int;
                                description = "Monitor refresh rate";
                            };
                            position = lib.mkOption {
                                type = lib.types.str;
                                description = "Monitor position";
                            };
                            scale = lib.mkOption {
                                type = lib.types.int;
                                description = "Monitor scale";
                            };
                        };
                    }
                );
                default = {
                    DP-3 = {
                        isMain = true;
                        port = "DP-3";
                        resolution = "2560x1440";
                        refreshRate = 180;
                        position = "-2560x0";
                        scale = 1;
                    };
                    DP-1 = {
                        port = "DP-1";
                        resolution = "3440x1440";
                        refreshRate = 144;
                        position = "0x0";
                        scale = 1;
                    };
                    DP-2 = {
                        port = "DP-2";
                        resolution = "2560x1440";
                        refreshRate = 180;
                        position = "3440x0";
                        scale = 1;
                    };
                };
                description = "Monitors to use";
            };
        };

        config = cfg: {
            # let
            #     monitors = [
            #         {
            #             port = "DP-3";
            #             resolution = "2560x1440";
            #             refreshRate = 180;
            #             position = "-2560x0";
            #             scale = 1;
            #         }
            #         {
            #             port = "DP-1";
            #             resolution = "3440x1440";
            #             refreshRate = 144;
            #             position = "0x0";
            #             scale = 1;
            #         }
            #         {
            #             port = "DP-2";
            #             resolution = "2560x1440";
            #             refreshRate = 180;
            #             position = "3440x0";
            #             scale = 1;
            #         }
            #     ];
            #
            #     mkMonitorKernelParam = m: "video=${m.port}:${m.resolution}@${toString m.refreshRate}";
            #     mkWaylandMonitor = m: "${m.port}, ${m.resolution}@${toString m.refreshRate}, ${m.position}, ${toString m.scale}";
            # in {
            #     boot.kernelParams = map mkMonitorKernelParam monitors;
            #     hm.wayland.windowManager.hyprland.settings.monitor = map mkWaylandMonitor monitors;
            # }
        };
    }
])
