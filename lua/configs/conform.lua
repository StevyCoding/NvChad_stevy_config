local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" }, 
    css = { "prettier" },
    html = { "prettier" },
    scss = {"prettier"},
    json = {"prettier"},
    java=  {"uncrustify"}
  },

  format_on_save = true
}

-- Add the uncrustify configuration
require('conform').setup({
  formatters = {
    uncrustify = {
      command = "uncrustify", 
      args = { 
        "-c", 
        "C:/uncrustify-0.80.1_f-win64/share/doc/uncrustify/examples/defaults.cfg",  -- Use forward slashes or double-backslashes
        "--replace",  -- This flag tells uncrustify to replace the file in place
        vim.fn.expand("%:p"),  -- Resolve the full path of the current file
      },
    },
  },
  format_on_save = options.format_on_save,
  filetypes = options.formatters_by_ft,
})

return options;
