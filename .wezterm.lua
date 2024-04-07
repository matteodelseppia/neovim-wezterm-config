-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Hybrid'
config.font_size = 16.0
config.font =
	wezterm.font('JetBrains Mono', {weight='ExtraBold'})	

config.colors = {
	cursor_bg = 'pink',
	selection_bg = 'white',
	foreground = 'lightblue'
}

img = "/Users/matteodelseppia/.wez_background.jpg"
config.window_background_image = img
config.window_background_opacity = 0.8
config.macos_window_background_blur = 20
-- and finally, return the configuration to wezterm
return config
