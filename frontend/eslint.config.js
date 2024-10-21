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
    },
    ignores: ['.node_modules/*', '.dist/**/*'],
    rules: {
      ...prettierConfig.rules,
      'vue/multi-word-component-names': 'off',
      eqeqeq: 'off',
      'no-unused-vars': 'error',
      'prefer-const': ['error', { ignoreReadBeforeAssign: true }],
    },
  }
);
