import js from "@eslint/js";
import globals from "globals";
import tseslint from "typescript-eslint";
import pluginReact from "eslint-plugin-react";
import { defineConfig } from "eslint/config";

export default defineConfig([
  // JavaScript / TypeScript / React files
  {
    files: ["**/*.{js,mjs,cjs,ts,mts,cts,jsx,tsx}"],
    plugins: { js },
    extends: ["js/recommended"],
    languageOptions: { globals: { ...globals.browser, ...globals.node } },
    rules: {
      "no-unused-vars": "warn",
      semi: ["error", "always"],
      quotes: ["error", "double"],
    },
  },

  // TypeScript recommended rules
  tseslint.configs.recommended,

  // React recommended rules
  pluginReact.configs.flat.recommended,

  // JSON & Markdown linting (syntax only)
  {
    files: ["**/*.{json,md}"],
    languageOptions: { globals: { ...globals.browser, ...globals.node } },
  },

  // Prettier integration (syntax + formatting)
  {
    files: ["**/*.{js,mjs,cjs,ts,mts,cts,jsx,tsx,json,md,css}"],
    ignores: ["node_modules", ".next"],
    rules: {
      "prettier/prettier": "error",
    },
    plugins: {
      prettier: require("eslint-plugin-prettier"),
    },
  },
]);
