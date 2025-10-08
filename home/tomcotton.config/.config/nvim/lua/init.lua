-- leader key is spacebar
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable filetype detection, plugins, and indent
vim.cmd('filetype on')
vim.cmd('filetype plugin on')
vim.cmd('filetype indent on')

-- Enable syntax highlighting
vim.cmd('syntax on')

-- Set line numbers with relative numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- Highlight cursor line underneath the cursor horizontally.
vim.opt.cursorline = true

-- Highlight cursor line underneath the cursor vertically.
vim.opt.cursorcolumn = true

-- Set shift width to 4 spaces.
vim.opt.shiftwidth = 4

-- Set tab width to 4 columns.
vim.opt.tabstop = 4

vim.opt.termguicolors = true
vim.cmd([[
  hi Cursor guibg=white
]])

-- Use space characters instead of tabs.
vim.opt.expandtab = true

-- Do not save backup files.
vim.opt.backup = false

-- Do not let cursor scroll below or above N number of lines when scrolling.
vim.opt.scrolloff = 12

-- Do not wrap lines. Allow long lines to extend as far as the line goes.
vim.opt.wrap = false

-- While searching though a file incrementally highlight matching characters as you type.
vim.opt.incsearch = true

-- Ignore capital letters during search.
vim.opt.ignorecase = true

-- Override the ignorecase option if searching for capital letters.
-- This will allow you to search specifically for capital letters.
vim.opt.smartcase = true

-- Show partial command you type in the last line of the screen.
vim.opt.showcmd = true

-- Show the mode you are on the last line.
vim.opt.showmode = true

-- Show matching words during a search.
vim.opt.showmatch = true

-- Use highlighting when doing a search.
vim.opt.hlsearch = true

-- Set the commands to save in history default number is 20.
vim.opt.history = 1000

-- Enable auto completion menu after pressing TAB.
vim.opt.wildmenu = true

-- Make wildmenu behave like similar to Bash completion.
vim.opt.wildmode = 'list:longest'

-- There are certain files that we would never want to edit with Vim.
-- Wildmenu will ignore files with these extensions.
vim.opt.wildignore = '*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx'

-- Use system clipboard
vim.opt.clipboard:append('unnamedplus')

-- FzfLua mappings under <leader>f
vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua files<CR>', { desc = 'Find files' })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Fuzzy search opened files history" })
vim.keymap.set('n', '<leader>fg', '<cmd>FzfLua live_grep<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>FzfLua buffers<CR>', { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>FzfLua help_tags<CR>', { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fo', '<cmd>FzfLua oldfiles<CR>', { desc = 'Old files' })
vim.keymap.set('n', '<leader>fc', '<cmd>FzfLua commands<CR>', { desc = 'Commands' })
vim.keymap.set('n', '<leader>fk', '<cmd>FzfLua keymaps<CR>', { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>fs', '<cmd>FzfLua git_status<CR>', { desc = 'Git status' })
vim.keymap.set('n', '<leader>fm', '<cmd>FzfLua marks<CR>', { desc = 'Marks' })

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox-material',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { "fugitive" },
}

local keymap = vim.keymap

keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git: show status" })
keymap.set("n", "<leader>gw", "<cmd>Gwrite<cr>", { desc = "Git: add file" })
keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git: commit changes" })
keymap.set("n", "<leader>gpl", "<cmd>Git pull<cr>", { desc = "Git: pull changes" })
keymap.set("n", "<leader>gpu", "<cmd>15 split|term git push<cr>", { desc = "Git: push changes" })
keymap.set("v", "<leader>gb", ":Git blame<cr>", { desc = "Git: blame selected line" })

-- convert git to Git in command line mode
-- vim.fn["utils#Cabbrev"]("git", "Git")

-- require('mini.diff').setup()
-- require('gitsigns').setup()

-- fugative
keymap.set("n", "<leader>gbn", function()
  vim.ui.input({ prompt = "Enter a new branch name" }, function(user_input)
    if user_input == nil or user_input == "" then
      return
    end

    local cmd_str = string.format("G checkout -b %s", user_input)
    vim.cmd(cmd_str)
  end)
end, {
  desc = "Git: create new branch",
})

keymap.set("n", "<leader>gf", ":Git fetch ", { desc = "Git: prune branches" })
keymap.set("n", "<leader>gbd", ":Git branch -D ", { desc = "Git: delete branch" })

-- barbar controls
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)

-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

-- Goto buffer in position...
map('n', '<leader>b1', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<leader>b2', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<leader>b3', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<leader>b4', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<leader>b5', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<leader>b6', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<leader>b7', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<leader>b8', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<leader>b9', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<leader>b0', '<Cmd>BufferLast<CR>', opts)

-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)

-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned

-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)

-- Wipeout buffer
--                 :BufferWipeout

-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight

-- Magic buffer-picking mode
map('n', '<leader>t', '<Cmd>BufferPick<CR>', opts)
map('n', '<leader>dt', '<Cmd>BufferPickDelete<CR>', opts)

-- Sort automatically by...
map('n', '<leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<leader>bn', '<Cmd>BufferOrderByName<CR>', opts)
map('n', '<leader>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    additional_vim_regex_highlighting = { 'ruby', 'markdown' },
  }
}
