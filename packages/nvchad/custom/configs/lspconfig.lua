local configs = require "plugins.configs.lspconfig"
local on_attach = configs.on_attach
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"
local servers = {
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

  -- bash
  "bashls",

  -- lua stuff
  "lua_ls",

  -- c/c++
  "clangd",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
