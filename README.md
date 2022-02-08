[![Codacy Badge](https://api.codacy.com/project/badge/Grade/13f8c6c0f4b947b89af4e5d99379b47d)](https://app.codacy.com/gh/tj-actions/eslint-changed-files?utm_source=github.com\&utm_medium=referral\&utm_content=tj-actions/eslint-changed-files\&utm_campaign=Badge_Grade_Settings)
[![Test](https://github.com/tj-actions/eslint-changed-files/actions/workflows/test.yml/badge.svg)](https://github.com/tj-actions/eslint-changed-files/actions/workflows/test.yml) [![Update release version.](https://github.com/tj-actions/eslint-changed-files/workflows/Update%20release%20version./badge.svg)](https://github.com/tj-actions/eslint-changed-files/actions?query=workflow%3A%22Update+release+version.%22) [![Public workflows that use this action.](https://img.shields.io/endpoint?url=https%3A%2F%2Fused-by.vercel.app%2Fapi%2Fgithub-actions%2Fused-by%3Faction%3Dtj-actions%2Feslint-changed-files%26badge%3Dtrue)](https://github.com/search?o=desc\&q=tj-actions+eslint-changed-files+language%3AYAML\&s=\&type=Code)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu\&logoColor=white)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
[![Mac OS](https://img.shields.io/badge/mac%20os-000000?logo=macos\&logoColor=F0F0F0)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
[![Windows](https://img.shields.io/badge/Windows-0078D6?logo=windows\&logoColor=white)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)

# eslint-changed-files

Run ESLint on either all files which performs slow in most cases or selectively run ESLint on only changed files in a pull request with support for
error reporting via GitHub checks.

<img width="1128" alt="Screen Shot 2022-01-01 at 9 26 14 PM" src="https://user-images.githubusercontent.com/17484350/147864446-89ea3bd0-b193-4c1d-b3ad-a47fa9acebf1.png">

## Features

*   Easy to debug
*   Fast execution
*   Glob pattern extension filtering
*   Excludes ignored files from change detection to prevent errors.
*   Github checks error reporting.
*   Github annotations with a possible resolution that can be applied to the Pull Request.

## Example

![Screen Shot 2021-09-06 at 1 15 22 PM](https://user-images.githubusercontent.com/17484350/132248250-6998078b-de5d-453a-8225-f4a6e3793bbe.png)

## Usage

```yml
...:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - uses: actions/setup-node@v2
        with:
          node-version: 14

      - name: Install dependencies
        run: npm ci  # OR: yarn 

      - name: Run eslint on changed files
        uses: tj-actions/eslint-changed-files@v9
        with:
          config_path: "/path/to/.eslintrc"
          ignore_path: "/path/to/.eslintignore"
          extra_args: "--max-warnings=0"
          file_extensions: |
            **/*.ts
            **/*.tsx
```

If you feel generous and want to show some extra appreciation:

Support this project with a :star:

[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]

[buymeacoffee]: https://www.buymeacoffee.com/jackton1

[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png

## Inputs

<!-- AUTO-DOC-INPUT:START - Do not remove or modify this section -->

|      INPUT      |  TYPE  | REQUIRED |                  DEFAULT                   |                                                                                                                                                    DESCRIPTION                                                                                                                                                     |
|-----------------|--------|----------|--------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| all\_files       | string | false    |                                            | Run [ESlint](https://eslint.org/) on all matching<br>files                                                                                                                                                                                                                                                         |
| config\_path     | string | false    | `".eslintrc"`                              | [ESlint](https://eslint.org/) [configuration file](https://eslint.org/docs/user-guide/configuring/)                                                                                                                                                                                                                |
| extra\_args      | string | false    |                                            | Extra arguments passed to [ESlint](https://eslint.org/docs/user-guide/command-line-interface)<br>                                                                                                                                                                                                                  |
| file\_extensions | string | false    | `"**/*.ts\n**/*.tsx\n**/*.js\n**/*.jsx\n"` | List of file extensions to<br>watch for changes and run<br>[ESlint](https://eslint.org/) against                                                                                                                                                                                                                   |
| ignore\_path     | string | false    |                                            | [ESlint](https://eslint.org/) [ignore file](https://eslint.org/docs/user-guide/configuring/ignoring-code)                                                                                                                                                                                                          |
| token           | string | true     | `"${{ github.token }}"`                    | [GITHUB\_TOKEN](https://docs.github.com/en/free-pro-team@latest/actions/reference/authentication-in-a-workflow#using-the-github_token-in-a-workflow) or a repo scoped<br>[Personal Access Token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) |

<!-- AUTO-DOC-INPUT:END -->

*   Free software: [MIT license](LICENSE)

# Credits

*   https://github.com/reviewdog/reviewdog

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->

<!-- prettier-ignore-start -->

<!-- markdownlint-disable -->

<table>
  <tr>
    <td align="center"><a href="https://dev.clintonblackburn.com"><img src="https://avatars.githubusercontent.com/u/910510?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Clinton Blackburn</b></sub></a><br /><a href="https://github.com/tj-actions/eslint-changed-files/commits?author=clintonb" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->

<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
