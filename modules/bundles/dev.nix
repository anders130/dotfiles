{
    inputs,
    lib,
    pkgs,
    ...
}: let
    inherit (lib) mkDefault;
    inherit (pkgs.stdenv.hostPlatform) system;
in {
    hm.home.packages = [inputs.self.packages.${system}.git];
    modules.programs.cli = {
        claude.enable = mkDefault true;
        github-copilot-cli.enable = mkDefault true;
        nvix = {
            enable = mkDefault true;
            type = mkDefault "full";
        };
        tmux.enable = mkDefault true;
        commonTools.enable = mkDefault true;
    };
    environment = {
        systemPackages = with pkgs; [
            tokei
            nix-melt
            gemini-cli
            statix
            devenv
        ];
        shellAliases = {
            ask = "gemini";
        };
    };
}
