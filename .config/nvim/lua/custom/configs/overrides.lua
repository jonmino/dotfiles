local M = {}

M.lspconfig = {
  config = function()
    require "plugins.configs.lspconfig"
    require "custom.configs.lspconfig"
  end,
}

M.mason = {
  config = function()
    require "plugins.configs.mason"
    require "custom.configs.mason"
  end,
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "jay-babu/mason-null-ls.nvim",
  },
}

-- git support in nvimtree
M.nvimtree = {
  opts = {
    git = {
      enable = true,
    },

    renderer = {
      highlight_git = true,
      icons = {
        show = {
          git = true,
        },
      },
    },
  },
}

M.treesitter = {
  opts = {
    ensure_installed = {
      -- defaults
      "bash",
      "lua",
      "regex",
      "vim",

      -- Study
      "bibtex",
      "cpp",
      "latex",
      "make",
      "markdown",
      "python",
      "yaml",

      -- git
      "diff",
      "git_config",
      "git_rebase",
      "gitcommit",
      "gitignore",

      -- Additional Stuff
    },
    auto_install = true,
  },
}
return M
