local wezterm = require("wezterm")
local config = wezterm.config_builder()

function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "nightfox"
  else
    return "dawnfox"
  end
end

local process_icons = {
  ["docker"] = {
    { Text = wezterm.nerdfonts.linux_docker },
  },
  ["docker-compose"] = {
    { Text = wezterm.nerdfonts.linux_docker },
  },
  ["kuberlr"] = {
    { Text = wezterm.nerdfonts.linux_docker },
  },
  ["kubectl"] = {
    { Text = wezterm.nerdfonts.linux_docker },
  },
  ["nvim"] = {
    { Text = wezterm.nerdfonts.custom_vim },
  },
  ["vim"] = {
    { Text = wezterm.nerdfonts.dev_vim },
  },
  ["node"] = {
    { Text = wezterm.nerdfonts.mdi_hexagon },
  },
  ["zsh"] = {
    { Text = wezterm.nerdfonts.cod_terminal },
  },
  ["bash"] = {
    { Text = wezterm.nerdfonts.cod_terminal_bash },
  },
  ["btm"] = {
    { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
  },
  ["htop"] = {
    { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
  },
  ["cargo"] = {
    { Text = wezterm.nerdfonts.dev_rust },
  },
  ["go"] = {
    { Text = wezterm.nerdfonts.mdi_language_go },
  },
  ["lazydocker"] = {
    { Text = wezterm.nerdfonts.linux_docker },
  },
  ["git"] = {
    { Text = wezterm.nerdfonts.dev_git },
  },
  ["lua"] = {
    { Text = wezterm.nerdfonts.seti_lua },
  },
  ["wget"] = {
    { Text = wezterm.nerdfonts.mdi_arrow_down_box },
  },
  ["curl"] = {
    { Text = wezterm.nerdfonts.mdi_flattr },
  },
  ["gh"] = {
    { Text = wezterm.nerdfonts.dev_github_badge },
  },
  ["python"] = {
    { Text = wezterm.nerdfonts.dev_python },
  },
  ["python3"] = {
    { Text = wezterm.nerdfonts.dev_python },
  },
  ["ruby"] = {
    { Text = wezterm.nerdfonts.dev_ruby },
  },
  ["beam.smp"] = {
    { Text = wezterm.nerdfonts.custom_elixir },
  },
  ["elixir"] = {
    { Text = wezterm.nerdfonts.custom_elixir },
  },
  ["make"] = {
    { Text = wezterm.nerdfonts.seti_makefile },
  },
  ["fish"] = {
    { Text = wezterm.nerdfonts.dev_terminal },
  },
}

local function get_current_working_dir(tab)
  local current_dir = tab.active_pane.current_working_dir
  local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

  if current_dir == HOME_DIR then
    return "~"
  end

  return string.gsub(current_dir, "(.*[/\\])(.*)", "%2")
end

local function get_process(tab)
  local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
  if string.find(process_name, "kubectl") then
    process_name = "kubectl"
  end

  return wezterm.format(process_icons[process_name] or { { Text = string.format("%s:", process_name) } })
end

config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = "BackgroundColor",
}
-- config.term = "wezterm"
config.color_scheme = "tokyonight-day"
config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
config.font_size = 10
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 1
-- config.macos_window_background_blur = 20
config.initial_cols = 140
config.initial_rows = 40
config.switch_to_last_active_tab_when_closing_tab = true
config.window_close_confirmation = "NeverPrompt"
config.pane_focus_follows_mouse = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_frame = {
  font_size = 9,
  active_titlebar_bg = "#222436",
}
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.colors = {
  visual_bell = "#1e2030",
  tab_bar = {
    active_tab = {
      bg_color = "#222436",
      fg_color = "#82aaff",
    },
    inactive_tab = {
      bg_color = "#1e2030",
      fg_color = "#545c7e",
    },
    new_tab = {
      bg_color = "#191b28",
      fg_color = "#82aaff",
    },
    new_tab_hover = {
      bg_color = "#82aaff",
      fg_color = "#1e2030",
    },
    inactive_tab_hover = {
      bg_color = "#1e2030",
      fg_color = "#82aaff",
    },
  },
}

local direction_keys = {
  Left = "h",
  Down = "j",
  Up = "k",
  Right = "l",
  -- reverse lookup
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "META|CTRL" or "LEADER",
    action = wezterm.action_callback(function(win, pane)
      if resize_or_move == "resize" then
        win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
      else
        win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
      end
    end),
  }
end

local action = wezterm.action

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- move between split panes
  split_nav("move", "h"),
  split_nav("move", "j"),
  split_nav("move", "k"),
  split_nav("move", "l"),
  -- resize panes
  split_nav("resize", "h"),
  split_nav("resize", "j"),
  split_nav("resize", "k"),
  split_nav("resize", "l"),
  -- {
  --   mods = "CMD",
  --   key = "d",
  --   action = action.SplitHorizontal,
  -- },
  {
    key = '%',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '"',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    mods = "LEADER",
    key = "z",
    action = action.TogglePaneZoomState,
  },
  { key = "[", mods = "CMD", action = action.ActivateTabRelative(-1) },
  { key = "]", mods = "CMD", action = action.ActivateTabRelative(1) },
  { key = "[", mods = "CMD|SHIFT", action = action.MoveTabRelative(-1) },
  { key = "]", mods = "CMD|SHIFT", action = action.MoveTabRelative(1) },
  {
    mods = "LEADER",
    key = "p",
    action = action.ActivateCommandPalette,
  },
  {
    mods = "LEADER",
    key = "w",
    action = action.CloseCurrentPane({ confirm = false }),
  },
  {
    mods = "LEADER|SHIFT",
    key = "w",
    action = action.CloseCurrentTab({ confirm = false }),
  },
  {
    mods = "LEADER",
    key = ",",
    action = action.SpawnCommandInNewTab({
      cwd = os.getenv("WEZTERM_CONFIG_DIR"),
      args = {
        "nvim",
        os.getenv("WEZTERM_CONFIG_FILE"),
      },
    }),
  },
  { mods = "OPT", key = "LeftArrow", action = action.SendKey({ mods = "ALT", key = "b" }) },
  { mods = "OPT", key = "RightArrow", action = action.SendKey({ mods = "ALT", key = "f" }) },
  { mods = "CMD", key = "LeftArrow", action = action.SendKey({ mods = "CTRL", key = "a" }) },
  { mods = "CMD", key = "RightArrow", action = action.SendKey({ mods = "CTRL", key = "e" }) },
  { mods = "CMD", key = "Backspace", action = action.SendKey({ mods = "CTRL", key = "u" }) },
  {
    mods = "CMD",
    key = "c",
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(action.CopyTo("Clipboard"), pane)
    end),
  },
  {
    mods = "CMD",
    key = "a",
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(action.Nop, pane)
    end),
  },
  {
    mods = "LEADER",
    key = "r",
    action = action.RotatePanes("Clockwise"),
  },
  {
    mods = "LEADER|SHIFT",
    key = "r",
    action = action.RotatePanes("CounterClockwise"),
  },
  {
    mods = "LEADER",
    key = "g",
    action = action.PaneSelect({ mode = "SwapWithActive" }),
  },
  {
    mods = "LEADER",
    key = "c",
    action = action.SpawnTab("DefaultDomain")
  },
  {
    key = 's',
    mods = 'LEADER',
    action = action.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  },
}

config.key_tables = {
  resize_pane = {
    { key = 'LeftArrow', action = action.AdjustPaneSize { 'Left', 1 } },
    { key = 'h', action = action.AdjustPaneSize { 'Left', 1 } },

    { key = 'RightArrow', action = action.AdjustPaneSize { 'Right', 1 } },
    { key = 'l', action = action.AdjustPaneSize { 'Right', 1 } },

    { key = 'UpArrow', action = action.AdjustPaneSize { 'Up', 1 } },
    { key = 'k', action = action.AdjustPaneSize { 'Up', 1 } },

    { key = 'DownArrow', action = action.AdjustPaneSize { 'Down', 1 } },
    { key = 'j', action = action.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode by pressing escape
    { key = 'Escape', action = 'PopKeyTable' },
  },

}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(i - 1),
  })
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER|CTRL',
    action = wezterm.action.MoveTab(i - 1),
  })
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local has_unseen_output = false
  if not tab.is_active then
    for _, pane in ipairs(tab.panes) do
      if pane.has_unseen_output then
        has_unseen_output = true
        break
      end
    end
  end

  local title = string.format("%s  %s", get_process(tab), get_current_working_dir(tab))

  if tab.active_pane.is_zoomed then
    title = title .. " " .. wezterm.nerdfonts.md_alpha_z_box
  end

  if has_unseen_output then
    return {
      { Foreground = { Color = "#bb9af7" } },
      { Text = title },
    }
  end

  return {
    { Text = title },
  }
end)

wezterm.on("update-status", function(window, pane)
  if window:active_key_table() == "copy_mode" then
    window:set_right_status(wezterm.format({
      { Foreground = { Color = "#bb9af7" } },
      { Background = { Color = "#222436" } },
      { Text = wezterm.nerdfonts.oct_copy .. "  COPY  " },
    }))
  else
    window:set_right_status("")
  end
end)

config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
  regex = [[["'\s]([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["'\s]] .. "]",
  format = "https://www.github.com/$1/$3",
})

wezterm.on("gui-startup", function(cmd) -- set startup Window position
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():set_position(60, 60)
end)

return config
