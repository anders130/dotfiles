{
    pkgs,
    lib,
    ...
}: let
    inherit (lib) mapAttrs' nameValuePair;
    inherit (pkgs.local) caveman;
    skills = {
        caveman = "${caveman}/skills/caveman";
        caveman-commit = "${caveman}/skills/caveman-commit";
        caveman-help = "${caveman}/skills/caveman-help";
        caveman-review = "${caveman}/skills/caveman-review";
        caveman-compress = "${caveman}/caveman-compress";
    };
in {
    hm.home = {
        packages = [pkgs.github-copilot-cli];
        file = mapAttrs' (name: path:
            nameValuePair ".agents/skills/${name}" {source = path;})
        skills;
    };
}
