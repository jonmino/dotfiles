local M = {}

M.trouble = {}

M.mini_surround = {
  keys = function(_, keys)
    -- Populate the keys based on the user's options
    local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
    local opts = require("lazy.core.plugin").values(plugin, "opts", false)
    local mappings = {
      { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
      { opts.mappings.delete, desc = "Delete surrounding" },
      { opts.mappings.find, desc = "Find right surrounding" },
      { opts.mappings.find_left, desc = "Find left surrounding" },
      { opts.mappings.highlight, desc = "Highlight surrounding" },
      { opts.mappings.replace, desc = "Replace surrounding" },
      { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
    }
    mappings = vim.tbl_filter(function(m)
      return m[1] and #m[1] > 0
    end, mappings)
    return vim.list_extend(mappings, keys)
  end,
  opts = {
    mappings = {
      add = "gsa", -- Add surrounding in Normal and Visual modes
      delete = "gsd", -- Delete surrounding
      find = "gsf", -- Find surrounding (to the right)
      find_left = "gsF", -- Find surrounding (to the left)
      highlight = "gsh", -- Highlight surrounding
      replace = "gsr", -- Replace surrounding
      update_n_lines = "gsn", -- Update `n_lines`
    },
  },
}

M.nvim_dap_python = {
  config = function(_, opts)
    local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
    require("dap-python").setup(path)
    require("core.utils").load_mappings "dap_python"
  end,
  dependencies = {
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
  },
}

M.todo_comments = {
  keys = {
    {
      "<leader><Right>",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo comment",
    },
    {
      "<leader><Left>",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous todo comment",
    },
    { "<leader>tt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    { "<leader>tT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    { "<leader>ts", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    { "<leader>tS", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
  },
}

return M
