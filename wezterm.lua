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

-- Vim detection functions
local function is_vim(pane)
	local process_name = pane:get_foreground_process_name():lower()
	local title = pane:get_title():lower()
	local vim_patterns = { "nvim", "node", "neovim", "vim", "editor", "%.nvim%-qt$" }

	for _, pattern in ipairs(vim_patterns) do
		if process_name:find(pattern) or title:find(pattern) then
			return true
		end
	end
	return false
end

local function is_editor_pane(pane)
	return pane and is_vim(pane)
end

-- State management
wezterm.on("toggle-state-updated", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	overrides.term_visible = not (overrides.term_visible or false)
	window:set_config_overrides(overrides)
end)

-- Keybindings
config.keys = {
	-- Split panes
	{ key = "-", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- Pane navigation
	{ key = "LeftArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },

	-- Quick actions
	{
		key = "W",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { "nvim", wezterm.config_dir .. "/wezterm.lua" },
		}),
	},
	{
		key = "I",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SendString(
			"sam build && sam local invoke --docker-network lambda-network -e events/ses-s3-event.json\n"
		),
	},
	-- Toggle decorations
	{
		key = "D",
		mods = "CTRL|ALT",
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

	-- Terminal toggle (Ctrl-;)
	{
		key = ";",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local tab = window:active_tab()
			local panes = tab:panes()
			local editor_pane = nil
			local bottom_panes = {}

			for _, p in ipairs(panes) do
				if is_editor_pane(p) then
					editor_pane = p
				else
					table.insert(bottom_panes, p)
				end
			end

			if #bottom_panes > 0 then
				editor_pane:activate()
				window:perform_action(act.TogglePaneZoomState, editor_pane)
			else
				window:perform_action(
					act.SplitPane({
						direction = "Down",
						size = { Percent = 30 },
					}),
					pane
				)
			end
		end),
	},

	-- Toggle focus (Ctrl-t)
	{
		key = "t",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local current_pane = window:active_pane()
			local tab = window:active_tab()
			local panes = tab:panes()

			if is_editor_pane(current_pane) then
				for _, p in ipairs(panes) do
					if not is_editor_pane(p) then
						p:activate()
						return
					end
				end
			else
				for _, p in ipairs(panes) do
					if is_editor_pane(p) then
						p:activate()
						return
					end
				end
			end
		end),
	},
}

config.default_cwd = wezterm.home_dir

return config
