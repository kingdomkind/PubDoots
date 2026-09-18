return function(x)
    local function contains(t, value)
        for _, v in ipairs(t) do
            if v == value then
                return true
            end
        end
        return false
    end

    do
        --> For some reason, my card* handles are not stable, and hyprland's env doesn't allow me to escape :,
        --> so we resolve it in advance
        local handle = io.popen("readlink -f /dev/dri/by-path/pci-0000:07:00.0-card")
        local result = handle:read("*l")
        handle:close()
        hl.env("AQ_DRM_DEVICES", result)
        -- hl.env("CUDA_VISIBLE_DEVICES", "1")
    end

    -- The gpus come up in an inconsistent order, so the DPs can be offset if card0 comes up first
    local dp1 = { "DP-1", "DP-4" }
    local dp2 = { "DP-2", "DP-5" }
    for _, monitor in ipairs(dp1) do
        hl.monitor({
            output = monitor,
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
    end

    for _, monitor in ipairs(dp2) do
        hl.monitor({
            output = monitor,
            mode = "3840x2160@120",
            position = "0x0",
            scale = 1.333,
            bitdepth = 10,
            vrr = 1,
        })
    end

    --> Disabling tone mapping
    hl.window_rule({
        match = { class = ".*" },
        tonemap = "off",
    })

    --> VM
    hl.bind(x.c .. "+1", hl.dsp.exec_cmd("ddcutil setvcp 60 0x0f --model XV273K"))
    hl.bind(x.c .. "+2", hl.dsp.exec_cmd("ddcutil setvcp 60 0x11 --model XV273K"))
    hl.bind(x.c .. "+3", hl.dsp.exec_cmd("ddcutil setvcp 60 0x12 --model XV273K"))

    --> Per monitor workspaces
    local function map_workspace(workspace, flipped)
        local monitors = hl.get_monitors()
        for i, m in ipairs(monitors) do
            if m.focused then
                local should_offset = (contains(dp2, m.name)) ~= flipped
                return should_offset and (workspace + 10) or workspace
            end
        end
    end

    -- This sets the defualt workspace per monitor
    -- hl.get_monitors() doesn't return anything on config load, it's empty
    -- Instead, we listen to monitor added and manually set the target workspace to the monitor
    hl.on("monitor.added", function(monitor)
        hl.dispatch(hl.dsp.focus({
            monitor = monitor.name,
        }))

        hl.dispatch(hl.dsp.focus({
            workspace = tostring(map_workspace(1)),
            on_current_monitor = true,
        }))
    end)

    for i = 1, 9 do
        hl.bind(x.a .. "+" .. i, function()
            hl.dispatch(hl.dsp.focus({
                workspace = map_workspace(i, false),
                on_current_monitor = true,
            }))
        end)

        hl.bind(x.b .. "+" .. i, function()
            hl.dispatch(hl.dsp.window.move({
                workspace = map_workspace(i, false),
                follow = false,
            }))
        end)

        hl.bind(x.d .. "+" .. i, function()
            hl.dispatch(hl.dsp.focus({
                workspace = map_workspace(i, true),
                on_current_monitor = true,
            }))
        end)

        hl.bind(x.e .. "+" .. i, function()
            hl.dispatch(hl.dsp.window.move({
                workspace = map_workspace(i, true),
                follow = false,
            }))
        end)
    end
end
