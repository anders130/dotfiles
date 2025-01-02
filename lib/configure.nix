{lib, ...}: config:
# simplify lib for modules
lib
// {
    mkSymlink = lib.mkSymlink config.hm;
}
