{inputs, ...}: {
    flake.modules.homeManager.github-copilot-cli = {
        pkgs,
        lib,
        ...
    }: let
        inherit (lib) mapAttrs' nameValuePair;
        inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) caveman;
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
