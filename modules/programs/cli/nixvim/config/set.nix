{
    opts = {
        # tabstop
        tabstop = 4;
        shiftwidth = 4;
        softtabstop = 4;
        expandtab = true;

        # Minimal number of screen lines to keep above and below the cursor
        scrolloff = 10;
        # Show which line your cursor is on
        cursorline = true;

        # Make line numbers default
        number = true;
        relativenumber = true;

        # Enable mouse mode
        mouse = "a";

        # Sync clipboard between OS and Neovim.
        #  Remove this option if you want your OS clipboard to remain independent.
        #  See `:help 'clipboard'`
        clipboard = "unnamedplus";

        # Enable break indent
        breakindent = true;

        # Save undo history
        undofile = true;

        # Case-insensitive searching UNLESS \C or capital in search
        ignorecase = true;
        smartcase = true;

        # Keep signcolumn on by default
        signcolumn = "yes";

        # Decrease update time
        updatetime = 250;
        timeoutlen = 300;

        # -- Configure how new splits should be opened
        splitright = true;
        splitbelow = true;

        # Sets how neovim will display certain whitespace characters in the editor.
        #  See `:help 'list'`
        #  and `:help 'listchars'`
        list = true;
        listchars = {
            tab = "» ";
            trail = "·";
            nbsp = "␣";
        };

        # Preview substitutions live, as you type!
        inccommand = "split";

        # ! NOT ANYMORE Part of Kickstart
        # Set completeopt to have a better completion experience
        completeopt = "menuone,noselect";

        # NOTE: You should make sure your terminal supports this
        termguicolors = true;
    };
}
