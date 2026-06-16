{inputs, ...}: {
    flake-file.inputs.superpowers = {
        url = "github:obra/superpowers";
        flake = false;
    };
    ai.skillRepos.superpowers.src = inputs.superpowers;
}
