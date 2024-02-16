-- Pull in the wezterm API
local wezterm = require("wezterm")
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

-- Functions:
-- -- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

local function button_style(bg, fg)
	return wezterm.format {
		{ Background = { Color = fg } },
		{ Foreground = { Color = bg } },
		{ Text = SOLID_RIGHT_ARROW },
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end

local function new_tab(bg, text)
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

local function right_status_element(fg, next, text)
	return { Background = { Color = next } },
		{ Foreground = { Color = fg } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = fg } },
		{ Foreground = { Color = CRUST } },
		{ Text = text }
end

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

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
config.window_close_confirmation = "NeverPrompt"
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
wezterm.on(
	'format-tab-title',
	function(tab, tabs, panes, config, hover, max_width)
		local edge_background = CRUST
		local LEFT_SEPERATOR = SOLID_SLASH_LEFT .. SOLID_RECTANGLE
		local RIGHT_SEPERATOR = SOLID_RECTANGLE .. SOLID_SLASH_RIGHT
		local background
		local foreground
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
		local number = wezterm.truncate_right(tostring(tab.tab_index + 1), max_width - 4)

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
		stat_color = SAPPHIRE
	end
	if window:leader_is_active() then
		stat = "LDR"
		stat_color = MAUVE
	end

	-- Current working directory
	local shortcwd = function(fileurl)
		-- Nothing a little regex can't fix
		local filestr = fileurl.file_path
		return string.gsub(filestr, "(.*[/\\])(.*)", "%2")
	end
	-- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l). Not a big deal, but check in case
	local cwd = pane:get_current_working_dir()
	cwd = cwd and shortcwd(cwd) or ""

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
		{ Text = " " .. stat },
		{ Background = { Color = stat_color } },
		{ Foreground = { Color = CRUST } },
		{ Text = SOLID_RECTANGLE .. SOLID_SLASH_RIGHT },
		{ Background = { Color = CRUST } },
		{ Foreground = { Color = stat_color } },
		{ Text = SOLID_SLASH_RIGHT },
	})

	-- Right status
	-- Wezterm has a built-in nerd fonts
	-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
	window:set_right_status(
		wezterm.format { right_status_element(PEACH, CRUST, wezterm.nerdfonts.md_folder .. " " .. cwd .. " "), } ..
		wezterm.format { right_status_element(SAPPHIRE, PEACH, wezterm.nerdfonts.md_clock .. " " .. time .. " ") } ..
		wezterm.format { right_status_element(MAUVE, SAPPHIRE,
			wezterm.nerdfonts.md_calendar .. " " .. date .. " " .. SOLID_LEFT_ARROW) }
	)
end)

-- Keybindings
config.disable_default_key_bindings = true
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 2500 }
config.keys = {
	{ key = 'Tab',   mods = 'CTRL',       action = act.ActivateTabRelative(1) },
	{ key = 'Tab',   mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
	{ key = 'Enter', mods = 'ALT',        action = act.ToggleFullScreen },
	{ key = 'Space', mods = 'LEADER',     action = act.SendKey { key = 'Space', mods = 'CTRL' } }, -- To be able to send CTRL Space
	{ key = '+',     mods = 'CTRL',       action = act.IncreaseFontSize },
	{ key = '-',     mods = 'CTRL',       action = act.DecreaseFontSize },
	{ key = '-',     mods = 'LEADER',     action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
	{ key = '/',     mods = 'LEADER',     action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
	{ key = '0',     mods = 'CTRL',       action = act.ResetFontSize },
	{ key = 'f',     mods = 'CTRL',       action = act.Search 'CurrentSelectionOrEmptyString' },
	{ key = 'p',     mods = 'CTRL',       action = act.ActivateCommandPalette },
	{ key = 'R',     mods = 'CTRL|ALT',   action = act.ReloadConfiguration },
	{ key = '[',     mods = 'LEADER',     action = act.ActivateTabRelative(-1) },
	{ key = ']',     mods = 'LEADER',     action = act.ActivateTabRelative(1) },
	{ key = 'c',     mods = 'LEADER',     action = act.ActivateCopyMode },
	{
		key = "e",
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
	{ key = 'h', mods = 'CTRL', action = act.ActivatePaneDirection 'Left' },
	{ key = 'j', mods = 'CTRL', action = act.ActivatePaneDirection 'Down' },
	{ key = 'k', mods = 'CTRL', action = act.ActivatePaneDirection 'Up' },
	{ key = 'l', mods = 'CTRL', action = act.ActivatePaneDirection 'Right' },
	{
		key = 'm',
		mods = 'LEADER',
		action = act.ActivateKeyTable { name = 'move_tab', one_shot = false, prevent_fallback = false, replace_current = false, until_unknown = false }
	},
	{ key = 'n', mods = 'LEADER', action = act.ShowTabNavigator },
	{ key = 'o', mods = 'LEADER', action = act.RotatePanes 'Clockwise' },
	{ key = 'q', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
	{
		key = 'r',
		mods = 'LEADER',
		action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false, prevent_fallback = false, replace_current = false, until_unknown = false }
	},
	{ key = 't', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
	{ key = 'v', mods = 'CTRL',   action = act.PasteFrom 'Clipboard' },
	{ key = 'x', mods = 'LEADER', action = act.CloseCurrentTab { confirm = true } },
	{ key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = 'W',
		mods = 'LEADER',
		action = act.PromptInputLine {
			description = wezterm.format {
				{ Attribute = { Intensity = 'Bold' } },
				{ Foreground = { AnsiColor = 'Fuchsia' } },
				{ Text = 'Enter name for new workspace' },
			},
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace {
							name = line,
						},
						pane
					)
				end
			end),
		},
	},
	{ key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
}
config.key_tables = {
	move_tab = {
		{ key = 'Enter',  mods = 'NONE', action = act.PopKeyTable },
		{ key = 'Escape', mods = 'NONE', action = act.PopKeyTable },
		{ key = 'h',      mods = 'NONE', action = act.MoveTabRelative(-1) },
		{ key = 'j',      mods = 'NONE', action = act.MoveTabRelative(-1) },
		{ key = 'k',      mods = 'NONE', action = act.MoveTabRelative(1) },
		{ key = 'l',      mods = 'NONE', action = act.MoveTabRelative(1) },
	},

	resize_pane = {
		{ key = 'Enter',  mods = 'NONE', action = act.PopKeyTable },
		{ key = 'Escape', mods = 'NONE', action = act.PopKeyTable },
		{ key = 'h',      mods = 'NONE', action = act.AdjustPaneSize { 'Left', 1 } },
		{ key = 'j',      mods = 'NONE', action = act.AdjustPaneSize { 'Down', 1 } },
		{ key = 'k',      mods = 'NONE', action = act.AdjustPaneSize { 'Up', 1 } },
		{ key = 'l',      mods = 'NONE', action = act.AdjustPaneSize { 'Right', 1 } },
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


-- and finally, return the configuration to wezterm
return config
