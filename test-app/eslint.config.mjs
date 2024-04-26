import globals from "globals";
import path from "path";
import { fileURLToPath } from "url";
import { FlatCompat } from "@eslint/eslintrc";
import pluginJs from "@eslint/js";
import styleLintConfig from "stylelint-config-recommended";
import prettierConfig from "eslint-config-prettier";
import eslintPluginPrettierRecommended from "eslint-plugin-prettier/recommended";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const compat = new FlatCompat({
  baseDirectory: __dirname,
  recommendedConfig: pluginJs.configs.recommended,
});

export default [
  {
    languageOptions: { globals: globals.browser },
    settings: { react: { version: "detect" } },
  },
  {
    ignores: ["src/reportWebVitals.ts"],
  },
  ...compat.extends("standard-with-typescript").map((config) => ({
    ...config,
    files: ["**/*.tsx", "**/*.ts"],
    rules: {
      ...config.rules,
      "@typescript-eslint/semi": ["error", "always"],
      "@typescript-eslint/explicit-function-return-type": "off",
      "@typescript-eslint/no-floating-promises": "off",
      "@typescript-eslint/no-non-null-assertion": "off",
    },
  })),
  prettierConfig, // Turns off all ESLint rules that have the potential to interfere with Prettier rules.
  eslintPluginPrettierRecommended,
  {
    files: ["*.css"],
    rules: styleLintConfig.rules,
  },
];
