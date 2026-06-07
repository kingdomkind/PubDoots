local pl = require("pl.path")

return function(lib)
    local bar_empty = [[
background_opacity = 0.9
center = []
enabled = true
end = []
margin_edge = 0
margin_ends = 0
radius = 0
start = []
]]

    local body = [=[
# >> Bar <<
[bar]
order = [ "Top", "Left", "Bottom", "Right" ]

    [bar.Bottom]
    ]=] .. bar_empty .. [=[
    position = "bottom"

    [bar.Left]
    ]=] .. bar_empty .. [=[
    position = "left"

    [bar.Right]
    ]=] .. bar_empty .. [=[
    position = "right"

    [bar.Top]
    background_opacity = 0.9
    capsule = true
    end = [ "tray", "volume", "control-center" ]
    font_weight = 700
    margin_edge = 0
    margin_ends = 0
    radius = 0
    start = [ "workspaces", "screen_recorder", "notifications", "tray", "audio_visualizer", "media" ]

# >> SHELL <<
[shell]
telemetry_enabled = false

    [shell.panel]
    launcher_categories = false
    session_placement = "centered"

# >> WIDGETS <<
[widget.audio_visualizer]
scale = 1.75

[widget.media]
title_scroll = "always"
hide_when_no_media = true

[widget.tray]
drawer = true

[widget.screen_recorder]
filename_pattern = "quickrec_%Y%m%d_%H%M%S"
hide_inactive = true
script = "scripts/screen_recorder.lua"
type = "scripted"

# >> CONTROL CENTER <<
[[control_center.shortcuts]]
type = "wifi"

[[control_center.shortcuts]]
type = "bluetooth"

[[control_center.shortcuts]]
type = "caffeine"

[[control_center.shortcuts]]
type = "notification"

[[control_center.shortcuts]]
type = "power_profile"

[[control_center.shortcuts]]
type = "screen_recorder"

# >> MISC <<
[theme]
builtin = "Catppuccin"
source = "wallpaper"
wallpaper_scheme = "m3-rainbow"

[notification]
offset_y = 16
position = "top_center"

[audio]
enable_overdrive = true

[location]
auto_locate = true

[osd]
lock_keys = false
]=]

    return {
        desym = {
            files = {
                [lib.configd .. "noctalia/settings.toml"] = {
                    source = body,
                    uid = lib.uid,
                    gid = lib.gid,
                    mode = lib.mode,
                }
            }
        }
    }
end
