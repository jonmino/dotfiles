-- Pull in the wezterm API
local wezterm = require("wezterm")
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
return {
	tab_bar_style = {
		new_tab = new_tab(SURFACE0, SUBTEXT0),
		new_tab_hover = new_tab(SURFACE1, TEXT),
		window_hide = button_style(CRUST, PEACH),
		window_hide_hover = button_style(SURFACE0, YELLOW),
		window_maximize = button_style(CRUST, BLUE),
		window_maximize_hover = button_style(SURFACE0, SAPPHIRE),
		window_close = button_style(CRUST, RED),
		window_close_hover = button_style(SURFACE0, MAROON),
	}
}
