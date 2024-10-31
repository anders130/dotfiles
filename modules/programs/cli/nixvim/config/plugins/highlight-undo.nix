{pkgs, ...}: {
    extraPlugins = [pkgs.vimPlugins.highlight-undo-nvim];

    extraConfigLuaPre = /*lua*/''
        require("highlight-undo").setup {}
    '';
}
