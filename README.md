# eslint-changed-files
Github action to run eslint on changed files.

```action

- name: Run ESLint on changed files
  uses: jackton1/eslint-changed-files@0.0.2
  with:
    base-branch: ${{ github.base_ref }}
    config-path: '/path/to/.eslintrc'
    ignore-path: '/path/to/.eslintignore'
```
