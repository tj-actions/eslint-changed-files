# eslint-changed-files
Github action to run eslint on changed files.

```action

- name: Run ESLint on changed files
  uses: jackton1/eslint-changed-files@0.1.0
  with:
    config-path: '/path/to/.eslintrc'
    ignore-path: '/path/to/.eslintignore'
    extensions: 'ts,tsx,js,jsx'
    extra-args: '--max-warnings=0'
```


## Inputs

|   Name        |    type   |  required     |  default              |
|:-------------:|:---------:|:-------------:|:---------------------:|
| token         |  string   |    false      |  ${{ github.token }}  |
| config-path   |  string   |    false      |  '.eslintrc'          |
| ignore-path   |  string   |    false      |  ''                   |
| extensions    |  string[] |    false      |  'ts,tsx,js,jsx'      |
| extra-args    |  string   |    false      |  ''                   |
