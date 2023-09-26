local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion

local sources = {
	-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
	completion.spell,
	diagnostics.shellcheck,

	-- bash
	formatting.beautysh.with {
		extra_args = function(params)
			return params.options
				and params.options.tabSize
				and {
					"--indent-size",
					params.options.tabSize,
				}
		end,
	},

	-- c/c++
	formatting.clang_format,

	-- lua
	formatting.stylua,

	-- nix
	formatting.alejandra,

	-- markdown
	formatting.yamlfix,
	formatting.taplo,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup {
	debug = true,
	sources = sources,
	on_attach = function(client, bufnr)
		if client.supports_method "textDocument/formatting" then
			vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format { async = false }
				end,
			})
		end
	end,
}
