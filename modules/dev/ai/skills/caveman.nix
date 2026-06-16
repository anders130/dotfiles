{inputs, ...}: {
    flake-file.inputs.caveman = {
        url = "github:JuliusBrussee/caveman";
        flake = false;
    };
    ai.skillRepos.caveman.src = inputs.caveman;
}
