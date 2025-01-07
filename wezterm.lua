local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

wezterm.log_info("Config loading...")

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
			"#3c3836", -- black
			"#ea6962", -- red
			"#a9b665", -- green
			"#d8a657", -- yellow
			"#7daea3", -- blue
			"#d3869b", -- magenta
			"#89b482", -- cyan
			"#d4be98", -- white
		},
		brights = {
			"#5a524c", -- bright black
			"#ea6962", -- bright red
			"#a9b665", -- bright green
			"#d8a657", -- bright yellow
			"#7daea3", -- bright blue
			"#d3869b", -- bright magenta
			"#89b482", -- bright cyan
			"#d4be98", -- bright white
		},
	},
}

--Font configuration
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 11.0

-- Color scheme
config.color_scheme = "GruvboxMaterial"

-- Window appearance
config.window_background_opacity = 0.98
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 12,
	right = 4,
	top = 12,
	bottom = 4,
}

-- PowerShell configuration
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
       Set-PSReadlineKeyHandler -Key Tab -Function Complete
       Set-PSReadLineOption -EditMode Emacs
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

	--close pane (ALT+w)
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
		action = act.SendString(
			"sam build && sam local invoke --docker-network lambda-network -e events/ses-s3-event.json\n"
		),
	},
}

config.default_cwd = wezterm.home_dir

return config
