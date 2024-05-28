local options  = {
    git = {
        enable = true,
        ignore = false,
        timeout = 500,
      },
actions = {
open_file = {
resize_window = true,
},
},
update_focused_file = {
  enable = true,
},
view = {
side = "left",
adaptive_size = true
},
filters = {
dotfiles = false,
}
}

require("nvim-tree").setup(options)