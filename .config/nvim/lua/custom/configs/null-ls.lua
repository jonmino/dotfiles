local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local status, null_ls = pcall(require, "null-ls")
if not status then
  return
end

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local opts = {
  sources = {
    -- Default -> Nvim Config
    lint.selene,
    formatting.stylua,
    lint.shellcheck,
    formatting.shfmt,

    -- Latex & Markdown
    lint.vale,
    formatting.latexindent,
    formatting.prettier,

    -- yaml
    lint.yamllint,
    -- formatting.prettier,

    -- Python
    lint.flake8,
    lint.ruff,
    formatting.black,

    -- C++
    lint.cpplint,
    formatting.clang_format.with {
      generator_opts = {
        "--style='Google'",
      },
    },
  },
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
  debug = true,
}
return opts
