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
local MANTLE = "#181825"
local SURFACE0 = "#313244"
local SURFACE1 = "#45475a"
local TEXT = "#cdd6f4"
local SUBTEXT0 = "#a6adc8"
local RED = "#f38ba8"
local MAROON = "#eba0ac"
local PEACH = "#fab387"
local YELLOW = "#f9e2af"
local BLUE = "#89b4fa"
local SAPPHIRE = "#74c7ec"
local SKY = "#89dceb"
local MAUVE = "#cba6f7"
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
local CHEVRON_RIGHT = wezterm.nerdfonts.fa_chevron_left

-- Basic Settings:
-- change default domain to WSL
config.default_domain = "WSL:Ubuntu"
config.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte, nord
config.font = wezterm.font_with_fallback({
	{ family = "FiraCode Nerd Font Mono",                 weight = "Medium", italic = false, scale = 1.25 },
	{ family = "MesloLGS NF",                             scale = 1.25 },
	{ family = "SourceCodePro+Powerline+Awesome+Regular", scale = 1.25 },
})
config.adjust_window_size_when_changing_font_size = false
config.font_size = 12.5
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
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE" -- TITLE und RESIZE / INTEGRATED_BUTTONS|RESIZE
config.integrated_title_button_style = "Windows"          -- Styles = Windows, MacOSNative, Gnome
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

function button_style(bg, fg)
	return wezterm.format {
		{ Background = { Color = fg } },
		{ Foreground = { Color = bg } },
		{ Text = SOLID_RIGHT_ARROW },
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end

function new_tab(bg, text)
	return wezterm.format {
		{ Background = { Color = CRUST } },
		{ Foreground = { Color = bg } },
		{ Text = SOLID_SLASH_LEFT },
		{ Background = { Color = bg } },
		{ Foreground = { Color = text } },
		{ Text = "+" },
		{ Background = { Color = CRUST } },
		{ Foreground = { Color = bg } },
		{ Text = SOLID_SLASH_RIGHT },
	}
end

wezterm.on(
	'format-tab-title',
	function(tab, tabs, panes, config, hover, max_width)
		local edge_background = CRUST
		local LEFT_SEPERATOR = SOLID_SLASH_LEFT .. SOLID_RECTANGLE
		local RIGHT_SEPERATOR = SOLID_RECTANGLE .. SOLID_SLASH_RIGHT

		if tab.is_active then
			background = BASE
			foreground = PEACH
		elseif hover then
			background = SURFACE0
			foreground = SKY
		else
			background = CRUST
			foreground = SAPPHIRE
		end

		local edge_foreground = background

		local title = tab_title(tab)
		-- ensure that the titles fit in the available space,
		-- and that we have room for the edges.
		title = wezterm.truncate_right(title, max_width - 6)
		number = wezterm.truncate_right(tostring(tab.tab_index + 1), max_width - 4)

		return {
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = LEFT_SEPERATOR },
			{ Background = { Color = background } },
			{ Foreground = { Color = foreground } },
			{ Text = title },
			{ Background = { Color = foreground } },
			{ Foreground = { Color = background } },
			{ Text = RIGHT_SEPERATOR },
			{ Text = number },
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = foreground } },
			{ Text = SOLID_SLASH_RIGHT },
		}
	end
)
config.tab_bar_style = {
	new_tab = new_tab(SURFACE0, SUBTEXT0),
	new_tab_hover = new_tab(SURFACE1, TEXT),
	window_hide = button_style(CRUST, PEACH),
	window_hide_hover = button_style(SURFACE0, YELLOW),
	window_maximize = button_style(CRUST, BLUE),
	window_maximize_hover = button_style(SURFACE0, SAPPHIRE),
	window_close = button_style(CRUST, RED),
	window_close_hover = button_style(SURFACE0, MAROON),
}

-- Right Stauts
wezterm.on("update-status", function(window, pane)
	-- Workspace name
	local stat = window:active_workspace()
	local stat_color = RED
	-- It's a little silly to have workspace name all the time
	-- Utilize this to display LDR or current key table name
	if window:active_key_table() then
		stat = window:active_key_table()
		stat_color = SKY
	end
	if window:leader_is_active() then
		stat = "LDR"
		stat_color = MAUVE
	end

	-- Current working directory
	local basename = function(s)
		-- Nothing a little regex can't fix
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end
	-- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l). Not a big deal, but check in case
	local cwd = pane:get_current_working_dir()
	cwd = cwd and basename(cwd) or ""
	-- Current command
	local cmd = pane:get_title()
	cmd = cmd and basename(cmd) or ""

	-- Time
	local time = wezterm.strftime("%H:%M")
	local date = wezterm.strftime("%Y-%m-%d")

	-- Left status (left of the tab line)
	window:set_left_status(wezterm.format {
		{ Background = { Color = CRUST } },
		{ Foreground = { Color = stat_color } },
		{ Text = SOLID_RECTANGLE },
		{ Background = { Color = stat_color } },
		{ Foreground = { Color = CRUST } },
		{ Text = wezterm.nerdfonts.md_desktop_tower .. " " },
		{ Background = { Color = CRUST } },
		{ Foreground = { Color = stat_color } },
		{ Text = SOLID_SLASH_RIGHT },
		{ Background = { Color = CRUST } },
		{ Foreground = { Color = stat_color } },
		{ Text = " " .. stat },
		{ Background = { Color = stat_color } },
		{ Foreground = { Color = CRUST } },
		{ Text = SOLID_RECTANGLE .. SOLID_SLASH_RIGHT },
		{ Background = { Color = CRUST } },
		{ Foreground = { Color = stat_color } },
		{ Text = SOLID_SLASH_RIGHT },
	})

	-- Right status
	window:set_right_status(wezterm.format {
		-- Wezterm has a built-in nerd fonts
		-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
		{ Background = { Color = CRUST } },
		{ Foreground = { Color = PEACH } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = PEACH } },
		{ Foreground = { Color = CRUST } },
		{ Text = wezterm.nerdfonts.md_folder .. " " .. cwd .. " " },
		{ Background = { Color = PEACH } },
		{ Foreground = { Color = SKY } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = SKY } },
		{ Foreground = { Color = CRUST } },
		{ Text = wezterm.nerdfonts.md_clock .. " " .. time .. " " },
		{ Background = { Color = SKY } },
		{ Foreground = { Color = MAUVE } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = MAUVE } },
		{ Foreground = { Color = CRUST } },
		{ Text = wezterm.nerdfonts.md_calendar .. " " .. date .. " " .. SOLID_LEFT_ARROW },
	})
end)

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
	{
		key = "e", -- Renaming current Tab
		mods = "LEADER",
		action = act.PromptInputLine {
			description = wezterm.format {
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { Color = MAUVE } },
				{ Text = "Renaming Tab Title...:" },
			},
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end)
		}
	},
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
