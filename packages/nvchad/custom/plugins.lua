local plugins = {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				-- scripting
				"lua",
				"bash",
				"ruby",
				"python",

				-- configs
				"nix",
				"vim",

				-- markdown
				"yaml",
				"json",

				-- compiled
				"c",
				"cpp",
				"llvm",

				-- tools
				"dot",
				"doxygen",
				"cmake",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",

		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require "custom.configs.null-ls"
			end,
		},

		config = function()
			require "plugins.configs.lspconfig"
			require "custom.configs.lspconfig"
		end,
	},

	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				-- lua stuff
				"lua-language-server",
				"stylua",

				-- shell
				"bash-language-server",
				"beautysh",
				"shellcheck",

				-- c/c++
				"clangd",
				"clang-format",

				-- yaml
				"yaml-language-server",
				"yamlfix",

				-- toml
				"taplo",
			},
		},
	},

	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	},
}

return plugins
