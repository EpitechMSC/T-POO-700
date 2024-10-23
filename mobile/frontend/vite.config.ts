import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

// https://vitejs.dev/config/
export default defineConfig({
  build:{
    outDir: "../wwww"
  },
  plugins: [vue()],
  server: {
    proxy:{
      "/api": "http://localhost:4000"
    }
  }
});
