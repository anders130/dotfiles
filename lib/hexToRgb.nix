{lib, ...}: hex: let
    hexCharList = lib.stringToCharacters "0123456789abcdef";

    hexToDecimal = char: lib.lists.findFirstIndex (x: x == (lib.toLower char)) null hexCharList;
    twoCharHexToInt = hexStr: builtins.add (builtins.mul (hexToDecimal (builtins.substring 0 1 hexStr)) 16) (hexToDecimal (builtins.substring 1 1 hexStr));
in {
    red = twoCharHexToInt (builtins.substring 0 2 hex);
    green = twoCharHexToInt (builtins.substring 2 2 hex);
    blue = twoCharHexToInt (builtins.substring 4 2 hex);
}
