[![Test](https://github.com/tj-actions/eslint-changed-files/actions/workflows/test.yml/badge.svg)](https://github.com/tj-actions/eslint-changed-files/actions/workflows/test.yml) [![Update release version.](https://github.com/tj-actions/eslint-changed-files/workflows/Update%20release%20version./badge.svg)](https://github.com/tj-actions/eslint-changed-files/actions?query=workflow%3A%22Update+release+version.%22) [![Public workflows that use this action.](https://img.shields.io/endpoint?url=https%3A%2F%2Fapi-tj-actions1.vercel.app%2Fapi%2Fgithub-actions%2Fused-by%3Faction%3Dtj-actions%2Feslint-changed-files%26badge%3Dtrue)](https://github.com/search?o=desc\&q=tj-actions+eslint-changed-files+language%3AYAML\&s=\&type=Code)

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
        uses: tj-actions/eslint-changed-files@v6.5
        with:
          config_path: "/path/to/.eslintrc"
          ignore_path: "/path/to/.eslintignore"
          extensions: "ts,tsx,js,jsx"
          extra_args: "--max-warnings=0"
          exclude_path: | # or a single string "generated.tsx" 
            generated.tsx
```

## Inputs

|   Input        |    type     |  required     |  default             |  description   |
|:-------------:|:-----------:|:-------------:|:---------------------:|:--------------:|
| token         |  `string`   |    `false`    | `${{ github.token }}` | [GITHUB_TOKEN](https://docs.github.com/en/free-pro-team@latest/actions/reference/authentication-in-a-workflow#using-the-github_token-in-a-workflow) <br /> or a repo scoped <br /> [Personal Access Token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token)              |
| config_path   |  `string`   |    `false`    |  `'.eslintrc'`        | [eslint](https://eslint.org/) [configuration file](https://eslint.org/docs/user-guide/configuring/)  |
| ignore_path   |  `string`   |    `false`    |  `''`                 | [eslint](https://eslint.org/) [ignore file](https://eslint.org/docs/user-guide/configuring/ignoring-code)  |
| extensions    |  `string[]` |    `false`    |  `'ts,tsx,js,jsx'`    |  File extensions to run [eslint](https://eslint.org/) against |
| extra_args    |  `string`   |    `false`    |  `''`                 | Extra arguments passed to [eslint](https://eslint.org/docs/user-guide/command-line-interface) |
| exclude_path  |  `string or string[]`   |    `false`    |  `''`                 | A single path or <br> a List of files to exclude <br> which match the <br> listed extensions.

*   Free software: [MIT license](LICENSE)

If you feel generous and want to show some extra appreciation:

[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]

[buymeacoffee]: https://www.buymeacoffee.com/jackton1

[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png
