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
-- local mux = wezterm.mux
local act = wezterm.action

-- This is where you actually apply your config choices

-- change default domain to WSL
config.default_domain = "WSL:Ubuntu"

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte, nord

-- Font
config.font_size = 12
config.line_height = 1
config.font = wezterm.font_with_fallback({
	{ family = "FiraCode Nerd Font Mono", weight = "Medium", italic = false, scale = 1.2 },
	{ family = "MesloLGS NF", scale = 1.2 },
	{ family = "SourceCodePro+Powerline+Awesome+Regular", scale = 1.2 },
})

-- Background
-- config.window_background_image = "D:/OneDrive/Red_dimmed.png"
config.window_background_opacity = 0.95

config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 5000

config.default_workspace = "home"

-- Keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	-- Send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },
	-- Pane keybindings
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "/", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "s", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	-- Seperate Keybindins for resizing panes possible
	-- But WezTerm offers custom "mode" -> "KeyTable"
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },

	-- Tab Keybindins
	{ key = "n", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "ö", mods = "LEADER", action = act.ActivateTabRelative(-1) }, -- [ -> ISO-De
	{ key = "ä", mods = "LEADER", action = act.ActivateTabRelative(1) }, -- ] -> ISO-De
	{ key = "t", mods = "LEADER", action = act.ShowTabNavigator },
	-- KeyTable to move Tabs
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },

	-- Workspace
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}

-- Quickly navigate Tabs with Index
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

-- Config of KeyTables
config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	move_tab = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "j", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

-- Tab bar
config.window_decorations = "RESIZE" -- TITLE und RESIZE / INTEGRATED_BUTTONS|RESIZE
config.integrated_title_button_style = "Windows" -- Styles = Windows, MacOSNative, Gnome
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = false
wezterm.on("update-right-status", function(window, pane)
	-- Workspace name
	local stat = window:active_workspace()
	local stat_color = "#f7768e"
	-- Display current LDR or KeyTable Name
	if window:active_key_table() then
		stat = window:active_key_table()
		stat_color = "#7dcfff"
	end
	if window:leader_is_active() then
		stat = "LDR"
		stat_color = "#bb9af7"
	end

	-- Current working directory
	local basename = function(s)
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end
	local cwd = basename(pane:get_current_working_dir())
	-- Current command
	local cmd = basename(pane:get_foreground_process_name())

	-- Time
	local time = wezterm.strftime("%H:%M")

	window:set_right_status(wezterm.format({
		{ Foreground = { Color = stat_color } },
		{ Text = wezterm.nerdfonts.oct_table .. " " .. stat },
		"ResetAttributes",
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_folder .. " " .. cwd },
		-- { Text = " | " },
		-- { Foreground = { Color = "FFB86C" } },
		-- { Text = wezterm.nerdfonts.fa_code .. " " .. cmd },
		-- "ResetAttributes",
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock .. " " .. time },
		{ Text = " " },
	}))
end)

-- Scrollbar
config.enable_scroll_bar = false

-- inactive panes
config.inactive_pane_hsb = {
	saturation = 0.75,
	brightness = 0.5,
}

config.adjust_window_size_when_changing_font_size = false

-- startup size
config.initial_rows = 36
config.initial_cols = 120

-- config.disable_default_key_bindings = true

-- and finally, return the configuration to wezterm
return config
