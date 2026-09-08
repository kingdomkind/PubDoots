hl.monitor({
    output = "DP-1",
    mode = "3840x2160@120",
    position = "0x0",
    scale = 1.333,
    bitdepth = 10,
    vrr = 1,
})

hl.monitor({
    output = "DP-2",
    mode = "3440x1440@144",
    position = "2880x0",
    scale = 1,
    bitdepth = 10,
    cm = "hdr",
    sdrbrightness = 1,
    sdrsaturation = 1,
    sdr_min_luminance = 0,
    sdr_max_luminance = 1405,
    min_luminance = 0,
    max_luminance = 1405,
    max_avg_luminance = 911,
})

hl.config({
    render = {
        cm_enabled = true,
        cm_auto_hdr = 0,
    },
})

-- Disable compositor tone mapping for all windows.
hl.window_rule({
    match = { class = ".*" },
    tonemap = "off",
})
