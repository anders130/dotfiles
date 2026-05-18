{
    pkgs,
    lib,
    ...
}: let
    inherit (lib) mapAttrs' nameValuePair;
    inherit (pkgs.local) caveman;
    skills = {
        cavecrew = "${caveman}/skills/cavecrew";
        caveman = "${caveman}/skills/caveman";
        caveman-commit = "${caveman}/skills/caveman-commit";
        caveman-compress = "${caveman}/caveman-compress";
        caveman-help = "${caveman}/skills/caveman-help";
        caveman-review = "${caveman}/skills/caveman-review";
        caveman-stats = "${caveman}/skills/caveman-stats";
    };
in {
    hm.home = {
        packages = [pkgs.github-copilot-cli];
        file = mapAttrs' (name: path:
            nameValuePair ".agents/skills/${name}" {source = path;})
        skills;
    };
}
