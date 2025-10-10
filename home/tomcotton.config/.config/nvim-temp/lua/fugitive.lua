vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git: show status" })
vim.keymap.set("n", "<leader>gw", "<cmd>Gwrite<cr>", { desc = "Git: add file" })
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git: commit changes" })
vim.keymap.set("n", "<leader>gpl", "<cmd>Git pull<cr>", { desc = "Git: pull changes" })
vim.keymap.set("n", "<leader>gpu", "<cmd>15 split|term git push<cr>", { desc = "Git: push changes" })
vim.keymap.set("v", "<leader>gb", ":Git blame<cr>", { desc = "Git: blame selected line" })

-- convert git to Git in command line mode
-- vim.fn["utils#Cabbrev"]("git", "Git")

-- require('mini.diff').setup()
-- require('gitsigns').setup()

-- fugative
vim.keymap.set("n", "<leader>gbn", function()
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

vim.keymap.set("n", "<leader>gf", ":Git fetch ", { desc = "Git: prune branches" })
vim.keymap.set("n", "<leader>gbd", ":Git branch -D ", { desc = "Git: delete branch" })
