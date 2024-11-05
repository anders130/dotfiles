{inputs, ...}: path: let
    inherit (builtins) substring stringLength;
    p = toString path;
    selfStrLen = stringLength inputs.self;
in
    substring
    (selfStrLen + 1)
    (stringLength p - selfStrLen - 1)
    p
