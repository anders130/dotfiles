{
    dots.gaming.provides.lsfg-vk.homeManager = {pkgs, ...}: {
        home.packages = with pkgs; [
            lsfg-vk
            lsfg-vk-ui
        ];
        xdg.dataFile."vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json".source = "${pkgs.lsfg-vk}/share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json";
    };
}
