{inputs, ...}: {
    perSystem = {lib, ...}: let
        inherit (builtins) attrNames concatStringsSep;
        inherit (lib) listToAttrs nameValuePair optional;

        hosts = inputs.self.nixosConfigurations;
        names = attrNames hosts;

        hostEntry = name: let
            r = hosts.${name}.config.readme;
        in {
            title = name;
            inherit (r) intro;
            sections =
                optional (r.install != "") {
                    title = "Installation";
                    content = r.install;
                }
                ++ r.sections;
        };

        hostIndex = concatStringsSep "\n" (map (n: "- [${n}](./hosts/${n})") names);
    in {
        readmeFiles = listToAttrs (map (n: nameValuePair "hosts/${n}/README.md" (hostEntry n)) names);
        rootReadme.sections = [
            {
                title = "Hosts";
                content = hostIndex;
            }
        ];
    };
}
