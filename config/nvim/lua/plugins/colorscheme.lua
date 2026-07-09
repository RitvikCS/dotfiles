-- Catppuccin Mocha, transparent: nvim paints no background so ghostty's
-- background-opacity (0.85 + Hyprland blur) shows through, matching the desktop.
return {
  {
    "catppuccin/nvim",
    opts = {
      flavour = "mocha",
      transparent_background = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- function form: ':colorscheme catppuccin' would resolve to the static
      -- port bundled in nvim 0.12's runtime, which ignores plugin options
      colorscheme = function()
        require("catppuccin").load("mocha")
      end,
    },
  },
}
