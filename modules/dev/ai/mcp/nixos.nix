{den, ...}: {
    den.aspects.ai.provides.mcp.nixos = {
        includes = [den.aspects.ai];
        homeManager = {
            lib,
            pkgs,
            ...
        }: {
            my.ai.providers.nixos.mcpServers.nixos.command = lib.getExe pkgs.mcp-nixos;
        };
    };
}
