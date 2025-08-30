// eslint.config.js — ESLint v9 (flat config)
import js from '@eslint/js'
import tseslint from 'typescript-eslint'
import vue from 'eslint-plugin-vue'
import vueParser from 'vue-eslint-parser'
import tsParser from '@typescript-eslint/parser'
import prettier from 'eslint-config-prettier'

export default [
  // sostituisce .eslintignore
  { ignores: ['dist', 'node_modules', 'coverage', '.vite'] },

  // JS base
  js.configs.recommended,

  // TypeScript
  ...tseslint.configs.recommended,
  {
    files: ['**/*.ts'],
    languageOptions: { parser: tsParser }
  },

  // Vue 3 + parser per SFC (.vue)
  ...vue.configs['flat/recommended'],
  {
    files: ['**/*.vue'],
    languageOptions: {
      parser: vueParser,
      parserOptions: {
        parser: tsParser,
        ecmaVersion: 'latest',
        sourceType: 'module',
        extraFileExtensions: ['.vue']
      }
    },
    rules: {
      'vue/multi-word-component-names': 'off' // consente App.vue, Wizard.vue, ecc.
    }
  },

  // Disattiva regole in conflitto con Prettier (se lo usi)
  prettier
]
