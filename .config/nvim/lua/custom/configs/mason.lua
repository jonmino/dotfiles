-- import mason
local mason = require "mason"
local config = require "plugins.configs.mason"

-- import mason-lspconfig
local mason_lspconfig = require "mason-lspconfig"

-- import mason-null-ls
local mason_null_ls = require "mason-null-ls"

-- enable mason and configure icons
mason.setup {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
  keymaps = config.keymaps,
  PATH = config.PATH,
  max_concurrent_installers = config.max_concurrent_installers,
}

mason_lspconfig.setup {
  -- list of servers for mason to install
  ensure_installed = {
    -- default
    "bashls",
    "lua_ls",
    "vimls",
    "grammarly",

    -- Study
    "clangd",
    "marksman",
    "pyright",
    "texlab",
    "yamlls",

    -- Additional
  },
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true, -- not the same as ensure_installed
}

mason_null_ls.setup {
  -- list of formatters & linters for mason to install
  ensure_installed = {
    -- default
    "stylua",
    "selene",
    "shellcheck",
    "shfmt",

    -- latex & markdown
    "vale",
    "latexindent",
    "prettier",

    -- yaml
    "yamllint",
    -- "prettier",

    -- Pyhton
    "black",
    "debugpy",
    "isort",
    "flake8",
    "ruff",

    -- C++
    "cpplint",
    "clang-format",
    "codelldb",
  },
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true,
}
