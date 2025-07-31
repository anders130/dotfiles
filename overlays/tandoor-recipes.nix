_: final: prev: {
    tandoor-recipes = prev.tandoor-recipes.overridePythonAttrs (old: {
        propagatedBuildInputs = old.propagatedBuildInputs ++ [prev.python3.pkgs.pyjwt];
    });
}
