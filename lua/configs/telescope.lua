
require("telescope.builtin").find_files({hidden = true})
require("telescope").load_extension "file_browser"

require("telescope").setup({
  defaults = {
      layout_config = {
        width = 1200,
      },
  },
})