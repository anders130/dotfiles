{
    den.aspects.github-copilot-cli.homeManager = {
        pkgs,
        lib,
        self',
        ...
    }: let
        inherit (lib) mapAttrs' nameValuePair;
        inherit (self'.packages) caveman;
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
        home = {
            packages = [pkgs.github-copilot-cli];
            file = mapAttrs' (name: path:
                nameValuePair ".agents/skills/${name}" {source = path;})
            skills;
        };
    };
}
