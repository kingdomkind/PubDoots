local terminal = "kitty"

--> Exec Onces
hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
end)

--> Environment Vars
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("XCURSOR_SIZE", "24")
hl.env("GTK_THEME", "Adwaita:dark")

--> General Config
hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 0,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        active_opacity = 1.0,
        fullscreen_opacity = 1.0,
        rounding = 0,
        blur = {
            enabled = true,
            passes = 3,
            size = 5,
        },
    },

    dwindle = {
        preserve_split = true,
    },

    input = {
        follow_mouse = 1,
        kb_layout = "us",
        touchpad = {
            natural_scroll = true,
        },
        repeat_delay = 250,
    },

    misc = {
        middle_click_paste = false,
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },

    animations = {
        enabled = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    ecosystem = {
        no_update_news = true,
    },
})

hl.device({
    name = "cx-2.4g-wireless-receiver-mouse",
    sensitivity = -0.5,
})

--> Animations
hl.curve("defaultBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "defaultBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "fadeLayersOut", enabled = false })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

--> Binds
local x = {
    a = "SUPER",
    b = "SUPER + SHIFT",
    d = "SUPER + CTRL",
    e = "SUPER + SHIFT + CTRL",

    c = "SUPER + SHIFT + ALT",
}

--> Non-compositor binds
hl.bind(x.a .. "+D", hl.dsp.exec_cmd("brave-origin --disable-features=WaylandWpColorManagerV1"))
hl.bind(x.a .. "+B", hl.dsp.exec_cmd("firefox"))
hl.bind(x.a .. "+Q", hl.dsp.exec_cmd(terminal))
hl.bind(x.a .. "+N", hl.dsp.exec_cmd("alacritty"))
hl.bind(x.a .. "+A", hl.dsp.exec_cmd("cosmic-files"))
hl.bind(x.a .. "+X", hl.dsp.exec_cmd(terminal .. " -e yazi"))
hl.bind(x.a .. "+U", hl.dsp.exec_cmd("env QT_SCALE_FACTOR=1.5 krita"))
hl.bind(x.a .. "+PAGE_UP", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind(x.a .. "+PAGE_DOWN", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })

--> Compositor binds
hl.bind(x.a .. "+C", hl.dsp.window.close())
hl.bind(x.a .. "+F", hl.dsp.window.fullscreen())
hl.bind(x.b .. "+F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "toggle" }))
hl.bind(x.a .. "+bracketright", hl.dsp.layout("swapsplit"))
hl.bind(x.a .. "+bracketleft", hl.dsp.layout("togglesplit"))
hl.bind(x.a .. "+V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(x.c .. "+M", hl.dsp.exit())
hl.bind(x.a .. "+right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(x.a .. "+left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(x.a .. "+up", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(x.a .. "+down", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })
hl.bind(x.a .. "+mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(x.a .. "+mouse:273", hl.dsp.window.resize(), { mouse = true })

--> Screenshots Binds
hl.bind(x.a .. "+S", hl.dsp.exec_cmd("grimblast --freeze copy area"))
hl.bind(x.b .. "+S",
    hl.dsp.exec_cmd(
        "grimblast --freeze --filetype ppm save area - | satty --filename - --copy-command \"wl-copy\" --early-exit --fullscreen --initial-tool brush"))

--> Noctalia Binds
local open = true
local function toggle_noctalia()
    if open == true then
        hl.config({
            general = {
                gaps_out = 0,
            },
        })

        hl.exec_cmd("noctalia msg bar-hide")
        open = false;
    else
        hl.config({
            general = {
                gaps_out = 50,
            },
        })

        hl.exec_cmd("noctalia msg bar-show")
        open = true;
    end
end

hl.bind(x.a .. "+SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(x.a .. "+R", hl.dsp.exec_cmd("noctalia msg wallpaper-random"))
hl.bind(x.c .. "+0", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
hl.bind(x.a .. "+E", toggle_noctalia)

--> Scratchpad Binds
local scratchpad_apps = {
    { "signal-desktop --disable-features=WaylandWpColorManagerV1", "signal" },
}

hl.bind(x.a .. "+Z", hl.dsp.workspace.toggle_special("scratchpad"))
for _, v in ipairs(scratchpad_apps) do
    hl.window_rule({ match = { class = v[2] }, workspace = "special:scratchpad" })
end

local cmd = ""
for _, v in ipairs(scratchpad_apps) do
    cmd = cmd .. v[1] .. " & "
end
cmd = cmd:sub(1, -3)

hl.workspace_rule({
    workspace = "special:scratchpad",
    on_created_empty = cmd,
})

local f = io.open(os.getenv("HOME") .. "/.config/hypr/hyprext.lua", "r")
if f then
    f:close()
    require("hyprext")(x)
end
