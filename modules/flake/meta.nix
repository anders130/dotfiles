{lib, ...}: {
    options.meta = lib.mkOption {
        type = lib.types.anything;
        default = {};
    };
    config.meta.owner = {
        email = "93037023+anders130@users.noreply.github.com";
        name = "anders130";
    };
}
