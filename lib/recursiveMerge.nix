{lib, ...}: sets: lib.foldl' (acc: set: lib.attrsets.recursiveUpdate acc set) {} sets
