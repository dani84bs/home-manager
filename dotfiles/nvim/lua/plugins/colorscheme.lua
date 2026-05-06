return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim", lazy = true, opts = {
    dim_inactive = true,
  } },

  -- configure catpuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
    },
  },

  -- Configure LazyVim to load desired colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
