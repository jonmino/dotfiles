local M = {}

M.dressing = {
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("lazy").load { plugins = { "dressing.nvim" } }
      return vim.ui.select(...)
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      require("lazy").load { plugins = { "dressing.nvim" } }
      return vim.ui.input(...)
    end
  end,

  opts = { -- Wrong bg implementation fix, default 10, wanted 30,
    input = {
      win_options = {
        winblend = 0,
      },
    },
    nui = {
      win_options = {
        winblend = 0,
      },
    },
    win_options = {
      winblend = 0,
    },
  },
}

M.indent_blankline = {
  opts = {
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    show_current_context = true,
    show_current_context_start = true,
    show_end_of_line = true,
    space_char_blankline = " ",
  },
}

M.lightbulb = {
  opts = {
    autocmd = {
      enabled = true,
    },
  },
}

M.noice = {
  config = function()
    return require "custom.configs.noice"
  end,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
}

M.notify = {
  config = function()
    dofile(vim.g.base46_cache .. "notify")
    require("notify").setup {
      background_colour = "#1e1e2e",
    }
  end,
}

M.nvim_dap_ui = {
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}

M.rainbow = {
  config = function()
    require "custom.configs.rainbow"
  end,
}

return M
