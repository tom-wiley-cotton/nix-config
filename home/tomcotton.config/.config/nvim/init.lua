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

-- Use space characters instead of tabs.
vim.opt.expandtab = true

-- Do not save backup files.
vim.opt.backup = false

-- Do not let cursor scroll below or above N number of lines when scrolling.
vim.opt.scrolloff = 10

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

-- fugitave
vim.opt.statusline = "%f %h%m%r%=%{exists('*FugitiveStatusline')?FugitiveStatusline():''} %-14.(%l,%c%V%) %P"

-- FzfLua mappings under <leader>f
vim.keymap.set('n', '<leader>fz', '<cmd>FzfLua files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>FzfLua live_grep<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>FzfLua buffers<CR>', { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>FzfLua help_tags<CR>', { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fo', '<cmd>FzfLua oldfiles<CR>', { desc = 'Old files' })
vim.keymap.set('n', '<leader>fc', '<cmd>FzfLua commands<CR>', { desc = 'Commands' })
vim.keymap.set('n', '<leader>fk', '<cmd>FzfLua keymaps<CR>', { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>fs', '<cmd>FzfLua git_status<CR>', { desc = 'Git status' })
vim.keymap.set('n', '<leader>fm', '<cmd>FzfLua marks<CR>', { desc = 'Marks' })

-- Lf.neovim
vim.keymap.set('n', '<leader>ff', '<cmd>Lf<CR>', { desc = 'List Files' })
-- Sample configuration is supplied
use({
    "lmburns/lf.nvim",
    config = function()
        -- This feature will not work if the plugin is lazy-loaded
        vim.g.lf_netrw = 1

        require("lf").setup({
            escape_quit = false,
            border = "rounded",
        })

        vim.keymap.set("n", "<M-o>", "<Cmd>Lf<CR>")

        vim.api.nvim_create_autocmd({
            event = "User",
            pattern = "LfTermEnter",
            callback = function(a)
                vim.api.nvim_buf_set_keymap(a.buf, "t", "q", "q", {nowait = true})
            end,
        })
    end,
    requires = {"toggleterm.nvim"}
})
