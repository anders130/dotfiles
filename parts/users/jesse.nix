{config, ...}: {
    flake.modules = config.flake.lib.mkUser "jesse" true;
}
