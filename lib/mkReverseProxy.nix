_: {
    port,
    extraConfig ? "",
    headers ? "",
}: {
    extraConfig = ''
        ${extraConfig}
        reverse_proxy :${toString port} {
            ${headers}
        }
    '';
}
