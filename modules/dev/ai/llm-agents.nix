{inputs, ...}: {
    flake-file.inputs.llm-agents.url = "github:numtide/llm-agents.nix";
    den.aspects.ai.nixos.nixpkgs.overlays = [inputs.llm-agents.overlays.default];
}
