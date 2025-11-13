pkgs: gamerules: let
    inherit (builtins) concatStringsSep map attrNames isBool;
    toValidString = actual:
        if isBool actual
        then
            (
                if actual
                then "true"
                else "false"
            )
        else toString actual;
    toGamerule = gamerule: "gamerule ${gamerule} ${toValidString gamerules.${gamerule}}";
    renderedGamerules =
        gamerules
        |> attrNames
        |> map toGamerule
        |> concatStringsSep "\n";
in
    pkgs.stdenvNoCC.mkDerivation {
        pname = "declarative-gamerules";
        version = "1.0.0";

        src = ./declarative-gamerules;

        buildPhase = ''
            runHook preBuild

            mkdir -p data/declarative_gamerules/function
            echo '${renderedGamerules}' > data/declarative_gamerules/function/setup.mcfunction

            runHook postBuild
        '';

        installPhase = ''
            runHook preInstall

            mkdir -p $out
            cp -r * $out

            runHook postInstall
        '';
    }
