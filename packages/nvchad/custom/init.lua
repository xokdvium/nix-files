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
vim.opt.colorcolumn = "80"

-- tab config stuff
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- how invisible characters
vim.opt.list = true
vim.opt.listchars = {
  extends = "→",
  precedes = "←",
  eol = "↵",
  nbsp = "+",
  trail = "·",
}
