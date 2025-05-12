local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
--wezterm.log_info("Config loading...")

-- Define color schemes
config.color_schemes = {
	["GruvboxMaterial"] = {
		foreground = "#d4be98",
		background = "#282828",
		cursor_bg = "#d4be98",
		cursor_fg = "#282828",
		cursor_border = "#d4be98",
		selection_fg = "#282828",
		selection_bg = "#d4be98",
		scrollbar_thumb = "#32302f",
		split = "#32302f",
		ansi = {
			"#3c3836",
			"#ea6962",
			"#a9b665",
			"#d8a657",
			"#7daea3",
			"#d3869b",
			"#89b482",
			"#d4be98",
		},
		brights = {
			"#5a524c",
			"#ea6962",
			"#a9b665",
			"#d8a657",
			"#7daea3",
			"#d3869b",
			"#89b482",
			"#d4be98",
		},
	},
	["Catppuccin Mocha"] = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"],
	["Catppuccin Macchiato"] = wezterm.color.get_builtin_schemes()["Catppuccin Macchiato"],
	["Catppuccin Frappe"] = wezterm.color.get_builtin_schemes()["Catppuccin Frappe"],
	["Catppuccin Latte"] = wezterm.color.get_builtin_schemes()["Catppuccin Latte"],
}

-- Set the default color scheme
config.color_scheme = "Catppuccin Frappe"

-- Font configuration
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 11.0

-- Window appearance
config.window_background_opacity = 0.98
config.hide_tab_bar_if_only_one_tab = true
-- config.window_padding = {
-- 	left = 12,
-- 	right = 4,
-- 	top = 12,
-- 	bottom = 4,
-- }

-- Default program (PowerShell)
config.default_prog = {
	"pwsh.exe",
	"-NoLogo",
	"-NoExit",
	"-Command",
	[[
        function prompt {
            $path = $PWD.Path.Replace($HOME, "~")
            "$path > "
        }
        Set-Alias touch New-Item
        Set-PSReadLineKeyHandler -Key Ctrl+n -Function NextHistory
        Set-PSReadLineKeyHandler -Key Ctrl+p -Function PreviousHistory
        Set-PSReadLineKeyHandler -Chord "Ctrl+y" -Function AcceptSuggestion
        Set-PSReadLineOption -EditMode Emacs
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle ListView
    ]],
}

-- Key bindings
config.keys = {
	-- Split panes
	{ key = "-", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Vim-style navigation (ALT + hjkl)
	{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	-- Zoom toggle (ALT+m)
	{ key = "m", mods = "ALT", action = act.TogglePaneZoomState },
	-- Close pane (ALT+w)
	{ key = "w", mods = "ALT", action = act.CloseCurrentPane({ confirm = false }) },
	-- Quick actions (restored from your original config)
	{
		key = "D",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action_callback(function(window, _pane)
			local overrides = window:get_config_overrides() or {}
			if not overrides.window_decorations then
				overrides.window_decorations = "NONE"
			else
				overrides.window_decorations = nil
			end
			window:set_config_overrides(overrides)
		end),
	},
	{
		key = "I",
		mods = "CTRL|SHIFT",
		action = act.SendString("sam build && sam local invoke -e events/sqs-test-event.json\n"),
	},
	-- Add a key binding to toggle between color schemes
	{
		key = "T",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			local overrides = window:get_config_overrides() or {}
			if overrides.color_scheme == "Catppuccin Frappe" then
				overrides.color_scheme = "Catppuccin Mocha"
			elseif overrides.color_scheme == "Catppuccin Mocha" then
				overrides.color_scheme = "Catppuccin Macchiato"
			elseif overrides.color_scheme == "Catppuccin Macchiato" then
				overrides.color_scheme = "Catppuccin Frappe"
			elseif overrides.color_scheme == "Catppuccin Frappe" then
				overrides.color_scheme = "Catppuccin Latte"
			else
				overrides.color_scheme = "GruvboxMaterial"
			end
			window:set_config_overrides(overrides)
		end),
	},
}

config.default_cwd = wezterm.home_dir

return config
