-- Set these keymaps only for the current buffer
-- vim.keymap.set with buffer = 0 makes the mapping local to this file
vim.keymap.set('n', 'j', 'gj', { buffer = 0, noremap = true })
vim.keymap.set('n', 'k', 'gk', { buffer = 0, noremap = true })
vim.opt_local.wrap = true

vim.fn['pencil#init']()
