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
  overrides: [
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    project: path.join(__dirname, 'tsconfig.json')
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
