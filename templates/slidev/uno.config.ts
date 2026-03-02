import type { IconifyJSON } from "@iconify/types";
import { defineConfig, presetIcons } from "unocss";

export default defineConfig({
    presets: [
        presetIcons({
            collections: {
                logos: async () =>
                    (await import("@iconify-json/logos/icons.json"))
                        .default as IconifyJSON,
                mdi: async () =>
                    (await import("@iconify-json/mdi/icons.json"))
                        .default as IconifyJSON,
                "simple-icons": async () =>
                    (await import("@iconify-json/simple-icons/icons.json"))
                        .default as IconifyJSON,
            },
        }),
    ]
});
