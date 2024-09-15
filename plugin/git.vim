" Title:        Git manipulation Plugin
" Description:  A plugin to run Git operations in Neovim
" Maintainer:   Ghislain Rodrigues <https://github.com/padawin>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_gitplugin")
    finish
endif
let g:loaded_gitplugin = 1

" Exposes the plugin's functions for use as commands in Neovim.
command! -nargs=0 Stage lua require("git.api").run_diff()
command! -nargs=0 StageFile lua require("git.api").run_file_diff()
command! -nargs=0 StageNextHunk lua require("git.api").run_next_hunk_diff()
