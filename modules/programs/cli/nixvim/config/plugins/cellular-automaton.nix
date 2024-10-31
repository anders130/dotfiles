{
    lib,
    pkgs,
    ...
}: {
    extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
        pname = "cellular-automaton.nvim";
        version = "2024-08-08";
        src = pkgs.fetchFromGitHub {
            owner = "Eandrju";
            repo = "cellular-automaton.nvim";
            rev = "11aea08aa084f9d523b0142c2cd9441b8ede09ed";
            hash = "sha256-nIv7ISRk0+yWd1lGEwAV6u1U7EFQj/T9F8pU6O0Wf0s=";
        };
        meta = {
            description = "Cellular automaton plugin for neovim";
            homepage = "https://github.com/Eandrju/cellular-automaton.nvim";
            license = lib.licenses.mit;
        };
    })];
}
