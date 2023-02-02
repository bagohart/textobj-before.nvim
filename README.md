# textobj-before.nvim
Neovim plugin that adds text objects to select the left part of a line before a separator (forward-seeking).

## Usage
`ib=` selects the left part of a one-line assignment, excluding leading whitespace and the `=`.  
`ab:` selects the left part of a line up to and including `:`, excluding leading whitespace.  
The text objects are forward-seeking, and start their search at the first column of the current line.

## Mappings
No default mappings, create some explicitly:
```lua
require('textobj-before.nvim').create_mappings({
    prefix_i = 'ib',
    prefix_a = 'ab',
    separators = { '=', ':', '/', [[\]], '|' },
    create_mark_on_jump_larger_than = 25,
})
```
This creates text-objects `ib=`, `ab=`, `ib:`, `ab:`, `ib/`, `ab/`, `ib\`, `ab\`, `ib|`, `ab|` in visual and operator-pending mode.  
This shadows the builtin `ib` and `ab` text-objects, but I prefer using `i(` anyway.  
As an intermediate step, `<Plug>(textobj-before-i=)` items are created to ensure that the output of `:omap ib=` is intelligible.  
The text objects are forward seeking, and if they skip more than `create_mark_on_jump_larger_than` lines, the `'` mark is set before the jump. Set the parameter to `nil` (or omit it) to disable this feature.

## Related Plugins
* [vim-textobj-before](https://github.com/bagohart/vim-textobj-before): My first attempt at this. A vimscript version of the same functionality, based on the `textobj-user` plugin. Works pretty good, but has a high startup time.
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
