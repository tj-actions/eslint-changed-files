const path = require('path')

module.exports = {
  env: {
    browser: true,
    es2021: true
  },
  extends: [
    'plugin:react/recommended',
    'standard-with-typescript'
  ],
  ignorePatterns: ['.eslintrc.js'],
  overrides: [
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    project: './tsconfig.json',
    tsconfigRootDir: __dirname,
  },
  plugins: [
    'react'
  ],
  rules: {
    '@typescript-eslint/triple-slash-reference': 'off'
  },
  settings: {
    react: {
      version: 'detect'
    }
  }
}
