import js from '@eslint/js';
import eslintPluginVue from 'eslint-plugin-vue';
import prettierConfig from 'eslint-config-prettier';
import ts from 'typescript-eslint';

export default ts.config(
  js.configs.recommended,
  ...ts.configs.recommended,
  ...eslintPluginVue.configs['flat/recommended'],
  {
    files: ['*.vue', '**/*.vue'],
    languageOptions: {
      parserOptions: {
        parser: '@typescript-eslint/parser',
      },
      globals: {
        module: 'readonly',
        describe: 'readonly',
        it: 'readonly',
        expect: 'readonly',
        on: 'readonly',
        config: 'readonly',
      },
    },
    rules: {
      ...prettierConfig.rules,
      'vue/multi-word-component-names': 'off',
    },
  }
);
