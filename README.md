[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge\&logo=ubuntu\&logoColor=white)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
[![Mac OS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge\&logo=macos\&logoColor=F0F0F0)](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on)
[![Public workflows that use this action.](https://img.shields.io/endpoint?style=for-the-badge\&url=https%3A%2F%2Fused-by.vercel.app%2Fapi%2Fgithub-actions%2Fused-by%3Faction%3Dtj-actions%2Feslint-changed-files%26badge%3Dtrue)](https://github.com/search?o=desc\&q=tj-actions+eslint-changed-files+language%3AYAML\&s=\&type=Code)

[![Test](https://github.com/tj-actions/eslint-changed-files/actions/workflows/test.yml/badge.svg)](https://github.com/tj-actions/eslint-changed-files/actions/workflows/test.yml) [![Update release version.](https://github.com/tj-actions/eslint-changed-files/workflows/Update%20release%20version./badge.svg)](https://github.com/tj-actions/eslint-changed-files/actions?query=workflow%3A%22Update+release+version.%22)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

# eslint-changed-files

Run ESLint on either all files or selectively run ESLint on only changed files in a pull request with support for inline annotations of ESLint Warnings & Errors.

![Screen Shot 2022-03-04 at 5 01 35 AM](https://user-images.githubusercontent.com/17484350/156742457-ff0c2da5-aca8-4260-9a3c-76ff3a273bd6.png)

## Features

*   Easy to debug
*   Fast execution
*   Fix ESlint errors
*   [Glob pattern](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#filter-pattern-cheat-sheet) extension filtering
*   Excludes ignored files from change detection.
*   Inline annotations of ESLint Warnings & Errors.
*   Inline annotations with possible resolutions that can be applied to the Pull Request.
*   Monorepo support.

## Example

![Screen Shot 2021-09-06 at 1 15 22 PM](https://user-images.githubusercontent.com/17484350/132248250-6998078b-de5d-453a-8225-f4a6e3793bbe.png)

## Usage

```yml

...:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20.x

      - name: Install dependencies
        run: npm ci  # OR: yarn install --frozen-lockfile

      - name: Run eslint on changed files
        uses: tj-actions/eslint-changed-files@v25
        with:
          config_path: "/path/to/eslint.config.mjs"
          extra_args: "--max-warnings=0"
```

For more working examples view the [test.yml](https://github.com/tj-actions/eslint-changed-files/blob/main/.github/workflows/test.yml)

If you feel generous and want to show some extra appreciation:

Support this project with a :star:

[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]

[buymeacoffee]: https://www.buymeacoffee.com/jackton1

[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png

## Inputs

<!-- AUTO-DOC-INPUT:START - Do not remove or modify this section -->

```yaml
- uses: tj-actions/eslint-changed-files@v25
  id: eslint-changed-files
  with:
    # Run [ESlint](https://eslint.org) on all matching 
    # files. 
    # Type: boolean
    # Default: "false"
    all_files: ''

    # [ESLint](https://eslint.org/) [configuration file](https://eslint.org/docs/user-guide/configuring/). Optionally omit this 
    # input for Mono repositories. 
    # Type: string
    config_path: ''

    # Escaped changed file paths passed 
    # to ESLint. NOTE: This defaults 
    # to `true` to prevent command 
    # injection. 
    # Type: boolean
    # Default: "true"
    escape_paths: ''

    # Extra arguments passed to [ESlint](https://eslint.org/docs/user-guide/command-line-interface)
    # Type: string
    extra_args: ''

    # Exit code for reviewdog when 
    # errors are found. 
    # Type: boolean
    # Default: "true"
    fail_on_error: ''

    # List of file extensions to 
    # watch for changes and run 
    # [ESlint](https://eslint.org/) against. 
    # Type: string
    # Default: **/*.{ts,tsx,js,jsx}
    #          
    file_extensions: ''

    # [Filter mode](https://github.com/reviewdog/reviewdog#filter-mode) for the reviewdog command 
    # (added, diff_context, file, nofilter). 
    # Type: string
    # Default: "added"
    filter_mode: ''

    # When using [ESlint](https://eslint.org/) `v8.x` use 
    # this option to pass the 
    # .eslintignore file to silence ignore 
    # files warning [ignore file](https://eslint.org/docs/latest/use/configure/ignore-deprecated#using-an-alternate-file) 
    # Type: string
    ignore_path: ''

    # [ESLint](https://eslint.org/docs/latest/use/configure/ignore) [configuration file](https://eslint.org/docs/latest/use/configure/ignore#ignoring-files) ignores key. Optionally 
    # ignoring files in the `ignores` 
    # key from being passed to 
    # ESLint, this input would be 
    # ignored when `all_files` is set 
    # to `true`. 
    # Type: string
    ignore_patterns: ''

    # Report level for reviewdog (info,warning,error)
    # Type: string
    # Default: "error"
    level: ''

    # Relative path under GITHUB_WORKSPACE to 
    # the repository 
    # Type: string
    # Default: "."
    path: ''

    # [Reporter](https://github.com/reviewdog/reviewdog#reporters) of reviewdog command (github-check, github-pr-review). 
    # github-pr-review can use Markdown and 
    # add a link to the 
    # rule page in reviewdog reports. 
    # Type: string
    # Default: "github-pr-review"
    reporter: ''

    # Skip running reviewdog i.e don't 
    # add any annotations. 
    # Type: boolean
    # Default: "false"
    skip_annotations: ''

    # Skip initially fetching additional history 
    # to improve performance for shallow 
    # repositories. NOTE: This could lead 
    # to errors with missing history. 
    # It's intended to be used 
    # when you've fetched all necessary 
    # history to perform the diff. 
    # Type: boolean
    # Default: "false"
    skip_initial_fetch: ''

    # [GITHUB TOKEN](https://docs.github.com/en/free-pro-team@latest/actions/reference/authentication-in-a-workflow#using-the-github_token-in-a-workflow) or a repo scoped [Personal Access Token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) 
    # Type: string
    # Default: "${{ github.token }}"
    token: ''

    # Force the use of Github's 
    # REST API even when a 
    # local copy of the repository 
    # exists 
    # Type: boolean
    # Default: "false"
    use_rest_api: ''

```

<!-- AUTO-DOC-INPUT:END -->

*   Free software: [MIT license](LICENSE)

# Credits

*   [reviewdog/reviewdog](https://github.com/reviewdog/reviewdog)
*   [tj-actions/changed-files](https://github.com/tj-actions/changed-files)

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->

<!-- prettier-ignore-start -->

<!-- markdownlint-disable -->

<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://dev.clintonblackburn.com"><img src="https://avatars.githubusercontent.com/u/910510?v=4?s=100" width="100px;" alt="Clinton Blackburn"/><br /><sub><b>Clinton Blackburn</b></sub></a><br /><a href="https://github.com/tj-actions/eslint-changed-files/commits?author=clintonb" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/sava-vidakovic"><img src="https://avatars.githubusercontent.com/u/10528914?v=4?s=100" width="100px;" alt="Sava Vidakovic"/><br /><sub><b>Sava Vidakovic</b></sub></a><br /><a href="https://github.com/tj-actions/eslint-changed-files/commits?author=sava-vidakovic" title="Code">💻</a> <a href="https://github.com/tj-actions/eslint-changed-files/commits?author=sava-vidakovic" title="Tests">⚠️</a> <a href="https://github.com/tj-actions/eslint-changed-files/commits?author=sava-vidakovic" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/codesculpture"><img src="https://avatars.githubusercontent.com/u/63452117?v=4?s=100" width="100px;" alt="Aravind"/><br /><sub><b>Aravind</b></sub></a><br /><a href="https://github.com/tj-actions/eslint-changed-files/commits?author=codesculpture" title="Code">💻</a> <a href="https://github.com/tj-actions/eslint-changed-files/commits?author=codesculpture" title="Documentation">📖</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->

<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
