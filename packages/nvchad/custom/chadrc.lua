---@type ChadrcConfig
local M = {}

M.lazy_nvim = { lockfile = vim.fn.stdpath "data" .. "/lazy-lock.json" }

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
