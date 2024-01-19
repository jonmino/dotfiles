-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- imports/aliases
local mux = wezterm.mux
local act = wezterm.action
-- Triangle left: "\uE0B0" -> 
-- Triangle right: "\uE0B2" -> 
-- Slash left: "\ue0ba" -> 
-- Slash right: "\ue0bc" -> 
-- Rectangle: "\u2588" -> █

-- Basic Settings:
-- change default domain to WSL
config.default_domain = "WSL:Ubuntu"
config.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte, nord
config.font = wezterm.font_with_fallback({
	{ family = "FiraCode Nerd Font Mono",                 weight = "Medium", italic = false, scale = 1.2 },
	{ family = "MesloLGS NF",                             scale = 1.2 },
	{ family = "SourceCodePro+Powerline+Awesome+Regular", scale = 1.2 },
})
config.adjust_window_size_when_changing_font_size = false
config.font_size = 12
config.line_height = 1
config.window_background_opacity = 0.925
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 5000
config.enable_scroll_bar = false
config.default_workspace = "main"
-- startup size
config.initial_rows = 36
config.initial_cols = 120

-- Visual Settings:
-- inactive panes
config.inactive_pane_hsb = {
	saturation = 0.75,
	brightness = 0.5,
}
-- Tab bar
config.window_decorations = "INTEGRATED_BUTTONS" -- TITLE und RESIZE / INTEGRATED_BUTTONS|RESIZE
config.integrated_title_button_style = "Windows" -- Styles = Windows, MacOSNative, Gnome
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = false

-- Keybindings
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 2500 }
config.keys = {
	-- Send C-Space when pressing C-Space twice
	{ key = " ", mods = "LEADER", action = act.SendKey({ key = " ", mods = "CTRL" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },
	-- Pane keybindings
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "/", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "CTRL",   action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL",   action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL",   action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL",   action = act.ActivatePaneDirection("Right") },
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	-- Seperate Keybindins for resizing panes possible
	-- But WezTerm offers custom "mode" -> "KeyTable"
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },

	-- Tab Keybindins
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = act.ShowTabNavigator },
	-- KeyTable to move Tabs
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
	-- Workspace
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}
-- Config of KeyTables
config.key_tables = {
	resize_pane = {
		{ key = "h",      action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j",      action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k",      action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l",      action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter",  action = "PopKeyTable" },
	},
	move_tab = {
		{ key = "h",      action = act.MoveTabRelative(-1) },
		{ key = "j",      action = act.MoveTabRelative(-1) },
		{ key = "k",      action = act.MoveTabRelative(1) },
		{ key = "l",      action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter",  action = "PopKeyTable" },
	},
}
-- Quickly navigate Tabs with Index
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end
-- config.disable_default_key_bindings = true

-- and finally, return the configuration to wezterm
return config
