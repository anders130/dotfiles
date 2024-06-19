{
    config,
    ...
}: let
    symlink = config.lib.file.mkOutOfStoreSymlink;
in{
    home.file = {
        Downloads.source = symlink "/mnt/data/Downloads";
        Music.source = symlink "/mnt/data/Music";
        Pictures.source = symlink "/mnt/data/Pictures";
        Videos.source = symlink "/mnt/data/Videos";
    };
}
