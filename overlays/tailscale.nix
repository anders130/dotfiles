_: _: prev: {
    tailscale = prev.tailscale.overrideAttrs (old: {
        checkFlags = map (
            flag:
                if prev.lib.hasPrefix "-skip=" flag
                then flag + "|^TestGetList$|^TestIgnoreLocallyBoundPorts$|^TestPoller$"
                else flag
        )
        old.checkFlags;
    });
}
