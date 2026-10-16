# Stemma's Homebrew tap

The Homebrew formulas of the Stemma organization (`stemma-math`).

```sh
brew install stemma-math/tap/stemma
```

| Formula         | Installs                                       |
| --------------- | ---------------------------------------------- |
| `stemma`        | `stemma`, from `stemma-math/stemma-exedra`     |
| `stemma-signum` | `stemma`, from `stemma-math/stemma-signum`     |

Both install a binary called `stemma`, so only one of them at a time.

## How it works

`packages.toml` lists each formula and the repository it comes from. The
formulas in `Formula/` are written from those repositories' releases by
`tools/update.py`: do not edit them by hand.

The **Update** workflow writes them and commits what changed. It runs:

- by hand, from *Actions → Update → Run workflow*, for one formula or all;
- when a repository announces a release, through the **Notify** workflow.

**Checks** installs and tests each formula, on macOS and Linux, on every
pull request and on `main`.

## Publishing a package here

A release must hold, for each target it is built for:

- an archive `<binary>-<version>-<target>.tar.gz`, with the binary inside
  (at its root, or in the archive's one directory);
- and a `SHA256SUMS` file, in the format `sha256sum` writes, listing it.

The version is the release's tag without its `v`. The targets known are
`aarch64-apple-darwin`, `x86_64-apple-darwin`, and `aarch64` or `x86_64`
with `unknown-linux-gnu` or `unknown-linux-musl`. The binary must answer
`--version` with its version.

To add a package, add it to `packages.toml` and run **Update** for it.

To have the tap update itself, call **Notify** once the release is
published:

```yaml
notify-tap:
  needs: publish
  uses: stemma-math/homebrew-tap/.github/workflows/notify.yml@main
  with:
    package: stemma
  secrets: inherit
```

It needs the organization secret `HOMEBREW_TAP_TOKEN`: a fine-grained
token that may write this repository's contents, and nothing else. Without
it, Notify only warns, and the formula is updated by hand.
