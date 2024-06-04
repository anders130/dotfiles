{
    ...
}: {
    imports = [
        ../neovim
    ];

    programs = {
        lsd = {
            enable = true;
            enableAliases = true;
        };
    };
}
