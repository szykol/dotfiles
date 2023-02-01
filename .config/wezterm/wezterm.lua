local wezterm = require"wezterm"

return {
  color_scheme = "Catppuccin Mocha",
  font = wezterm.font('JetBrains Mono'),

  window_decorations = "NONE",
  window_padding = {
    left = 1,
    right = 0,
    top = 2,
    bottom = 0,
  },

  tab_bar_at_bottom = true,
  hide_tab_bar_if_only_one_tab = true,

  enable_scroll_bar = false,
  term = "xterm-256color",
}
