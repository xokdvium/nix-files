-- remove trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- hightlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = "*",
})

-- ruler at column 80
vim.wo.colorcolumn = "80"

-- tab config stuff
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
