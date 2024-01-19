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
-- Colours
local BASE = "#1e1e2e"
local CRUST = "#11111b"
local SURFACE0 = "#313244"
local SURFACE1 = "#45475a"
local TEXT = "#cdd6f4"
local SUBTEXT0 = "#a6adc8"
local PEACH = "#fab387"
local SAPPHIRE = "#74c7ec"
local SKY = "#89dceb"
-- Symbols
-- The filled in variant of the (\uE0B0) symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
-- The filled in variant of the (\uE0B2) symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
-- Rectangle: "\u2588" -> █
local SOLID_RECTANGLE = "█"
-- Slash left: "\ue0ba" -> 
local SOLID_SLASH_LEFT = ""
-- Slash right: "\ue0bc" -> 
local SOLID_SLASH_RIGHT = ""

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
-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

function tab_number(tab_info)
	local number = tostring(tab_info.tab_index + 1)
	if number and #number > 0 then
		return number
	end
end

wezterm.on(
	'format-tab-title',
	function(tab, tabs, panes, config, hover, max_width)
		local edge_background = CRUST

		if tab.is_active then
			background = BASE
			foreground = PEACH
		elseif hover then
			background = SURFACE1
			foreground = SKY
		else
			background = CRUST
			foreground = SAPPHIRE
		end

		local edge_foreground = background

		local title = tab_title(tab)
		local number = tab_number(tab)
		-- ensure that the titles fit in the available space,
		-- and that we have room for the edges.
		title = wezterm.truncate_right(title, max_width - 4)
		number = wezterm.truncate_right(number, max_width - 4)

		return {
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = SOLID_SLASH_LEFT },
			{ Background = { Color = background } },
			{ Foreground = { Color = foreground } },
			{ Text = title },
			{ Background = { Color = foreground } },
			{ Foreground = { Color = background } },
			{ Text = SOLID_SLASH_RIGHT },
			{ Text = number },
			{ Background = { Color = background } },
			{ Foreground = { Color = foreground } },
			{ Text = SOLID_SLASH_RIGHT },
		}
	end
)
config.tab_bar_style = {
	new_tab = wezterm.format {
		{ Background = { Color = BASE } },
		{ Foreground = { Color = SURFACE0 } },
		{ Text = SOLID_SLASH_LEFT },
		{ Background = { Color = SURFACE0 } },
		{ Foreground = { Color = SUBTEXT0 } },
		{ Text = "+" },
		{ Background = { Color = CRUST } },
		{ Foreground = { Color = SURFACE0 } },
		{ Text = SOLID_SLASH_RIGHT },
	},
	new_tab_hover = wezterm.format {
		{ Background = { Color = BASE } },
		{ Foreground = { Color = SURFACE1 } },
		{ Text = SOLID_SLASH_LEFT },
		{ Background = { Color = SURFACE1 } },
		{ Foreground = { Color = TEXT } },
		{ Text = "+" },
		{ Background = { Color = CRUST } },
		{ Foreground = { Color = SURFACE1 } },
		{ Text = SOLID_SLASH_RIGHT },
	},
}

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
