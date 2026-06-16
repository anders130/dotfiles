{inputs, ...}: {
    flake-file.inputs.antigravity = {
        url = "github:sickn33/antigravity-awesome-skills";
        flake = false;
    };
    ai.skillRepos.antigravity = {
        src = inputs.antigravity;
        select = ["clean-code"];
    };
}
