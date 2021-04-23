[![Test](https://github.com/tj-actions/eslint-changed-files/actions/workflows/test.yml/badge.svg)](https://github.com/tj-actions/eslint-changed-files/actions/workflows/test.yml) [![Update release version.](https://github.com/tj-actions/eslint-changed-files/workflows/Update%20release%20version./badge.svg)](https://github.com/tj-actions/eslint-changed-files/actions?query=workflow%3A%22Update+release+version.%22) <a href="https://github.com/search?q=tj-actions+eslint-changed-files+path%3A.github%2Fworkflows+language%3AYAML&type=code" target="_blank" title="Public workflows that use this action."><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fapi-git-master.endbug.vercel.app%2Fapi%2Fgithub-actions%2Fused-by%3Faction%3Dtj-actions%2Feslint-changed-files%26badge%3Dtrue" alt="Public workflows that use this action."></a>


# eslint-changed-files
Github action to run eslint on only files that have changed in a pull request with support for excluding generated files.

```yml
...:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: 14
      - name: Install
        run: npm ci  # OR: yarn 
      - name: Run eslint on changed files
        uses: tj-actions/eslint-changed-files@v5.2
        with:
          config-path: "/path/to/.eslintrc"
          ignore-path: "/path/to/.eslintignore"
          extensions: "ts,tsx,js,jsx"
          extra-args: "--max-warnings=0"
          exclude-path: | # or a single string "generated.tsx" 
            generated.tsx
```


## Inputs

|   Input        |    type     |  required     |  default             |  description   |
|:-------------:|:-----------:|:-------------:|:---------------------:|:--------------:|
| token         |  `string`   |    `false`    | `${{ github.token }}` | [GITHUB_TOKEN](https://docs.github.com/en/free-pro-team@latest/actions/reference/authentication-in-a-workflow#using-the-github_token-in-a-workflow) <br /> or a repo scoped <br /> [Personal Access Token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token)              |
| config-path   |  `string`   |    `false`    |  `'.eslintrc'`        | [eslint](https://eslint.org/) [configuration file](https://eslint.org/docs/user-guide/configuring/)  |
| ignore-path   |  `string`   |    `false`    |  `''`                 | [eslint](https://eslint.org/) [ignore file](https://eslint.org/docs/user-guide/configuring/ignoring-code)  |
| extensions    |  `string[]` |    `false`    |  `'ts,tsx,js,jsx'`    |  File extensions to run [eslint](https://eslint.org/) against |
| extra-args    |  `string`   |    `false`    |  `''`                 | Extra arguments passed to [eslint](https://eslint.org/docs/user-guide/command-line-interface) |
| exclude-path  |  `string or string[]`   |    `false`    |  `''`                 | A single path or a List of files to exclude entirely which match the listed extensions.
