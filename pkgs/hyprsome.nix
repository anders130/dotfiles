# https://github.com/sopa0/hyprsome
{
    rustPlatform,
    fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
    pname = "hyprsome";
    version = "0.1.13";

    src = fetchFromGitHub {
        owner = "anders130";
        repo = "hyprsome";
        rev = "bf6c878e1bce9dd2c28200dcc0f0370e2677ea62";
        hash = "sha256-qMO9BidVWpxGu9UIV4iol9ybsZZCtKa4vsHNB5lkX+k=";
    };

    cargoLock.lockFile = "${src.outPath}/Cargo.lock";
}
