# AGENTS.md

This repository belongs to the Stemma organization (`stemma-math`).

## Language

- Write everything in this repository in English: code, identifiers,
  comments, documentation and commit messages. Conversations with the
  people you work with may be in any language.

## Git conventions

- Use Conventional Commits for commit messages. Avoid long descriptions in
  commit bodies, unless necessary.

## Organization defaults

- The organization's `.github` repository provides default issue and pull
  request templates. They are useful, but following them is not required
  unless this repository says otherwise.

## This repository

The organization's Homebrew tap.

- **Only this repository knows how the tap works.** Other repositories
  publish releases as the README says, and at most call `notify.yml`.
- **Formulas are written, not edited.** Change `packages.toml` or
  `tools/update.py`, then run them; never edit `Formula/` by hand.
