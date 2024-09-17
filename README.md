# Nvim Git

Another Git plugin for Neovim.

## Need to solve

I created this plugin as I did not find any plugin which handle well the `git
add -p` command. Most of these that I found allow to:
- commit a whole file
- maybe commit a hunk

But I haven't found any which allow to easily edit hunks to stage.

I therefore created this plugin.

## Features

### Stage changes

Changes can **only** be staged through a patch view phase (with possibility to
edit the patch, similar to `git add -p` -> `edit`).

Changes can be staged in 3 commands:

- `:NGitStage`: Opens a patch file with all the local changes. Useful to pick
  changes from different files at once.
- `:NGitStageFile`: Opens a patch file with all the changes of the current file.
- `:NGitStageNextHunk`: Opens a patch file with only the first available hunk after
  the cursor in the current file.

### Committing

The plugin handle commit operations.

The `:NGitCommit` command opens in a new tab a vertical split with:
- on one side an empty buffer to write the commit message,
- on the other side a buffer containing the staged changes.

## Mappings

The following mappings are available:

- `ga` (overrides native Vim mapping): Executes `:NGitStage` to start staging changes.
- `gc`: Executes `:NGitCommit` To commit changes.

## Bugs/Limitations

The plugin is probably heavily tailored to my needs, and lacks in features (I
might add some as I use it).

Reported bugs are available on Github: https://github.com/padawin/nvim-git/issues
