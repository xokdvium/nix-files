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
        -- methinks that this stuff should be manager by home-manager
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  },

  {
    "mcauley-penney/tidy.nvim",
    config = {
      filetype_exclude = { "markdown", "diff" },
    },
    init = function()
      vim.keymap.set("n", "<leader>te", require("tidy").toggle, {})
    end,
  },
}

return plugins
