# textobj-before.nvim
Neovim plugin: forward-seeking text objects which select the part of a line before a character.

## Why?
Text objects are awesome. The more, the better!  
Use e.g. `ib=` to select the left part of an assignment.  
The cursor needs to be on the same or a previous line.  
They are forward seeking, but always search on the same line first.

## Mappings
No default mappings, create them explicitly.  
The following call will create mappings for `ib=`, `ab=`, `ib:`, `ab:` and others:
```lua
require('textobj-before.nvim').create_mappings({
    prefix_i = 'ib',
    prefix_a = 'ab',
    separators = { '=', ':', '/', [[\]], '|' },
    create_mark_on_jump_larger_than = 25,
})
```
As an intermediate step, `<Plug>(textobj-before-i=)` objects are created to ensure that the output of `:omap ib=` is intelligible.
The text objects are forward seeking, and if they skip more than `create_mark_on_jump_larger_than` lines, the `'` mark is set before the jump. Set this to `nil` (or omit the parameter) to disable this feature.

# Related Plugins
* [vim-textobj-before](https://github.com/bagohart/vim-textobj-before): My first attempt at this. A vimscript version of the same functionality, based on the `textobj-user` plugin. Works pretty good, but has disturbing startup time.
* [vim-after-object](https://github.com/junegunn/vim-after-object): Select the right hand side of a line after a separator.

## Requirements
Developed and tested on Neovim `0.8.1`.

## Alternatives
If you don't need or want the forward-seeking functionality, consider creating very simple mappings instead, for example:
```lua
vim.keymap.set('o', 'ib=', ':exec "normal! ^vf=ge"<CR>')
vim.keymap.set('x', 'ib=', '<Esc>^vf=ge')
vim.keymap.set('o', 'ab=', ':exec "normal! ^vf="<CR>') 
vim.keymap.set('x', 'ab=', '<Esc>^vf=')
```
