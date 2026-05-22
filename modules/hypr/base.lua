local noctalia = "qs -c noctalia-shell"
local terminal = "kitty"

--> Exec Onces
hl.on("hyprland.start", function()
    hl.exec_cmd(noctalia)
    hl.exec_cmd("signal-desktop")
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
            passes = 2,
            size = 10,
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
local a = "SUPER"
local b = "SUPER + SHIFT"
local c = "SUPER + SHIFT + ALT"

--> Non-compositor binds
hl.bind(a .. "+D", hl.dsp.exec_cmd("brave-origin-nightly --enable-features=TouchpadOverscrollHistoryNavigation"))
hl.bind(a .. "+B", hl.dsp.exec_cmd("firefox"))
hl.bind(a .. "+Q", hl.dsp.exec_cmd(terminal))
hl.bind(a .. "+N", hl.dsp.exec_cmd("alacritty"))
hl.bind(a .. "+A", hl.dsp.exec_cmd("cosmic-files"))
hl.bind(a .. "+X", hl.dsp.exec_cmd(terminal .. " -e yazi"))
hl.bind(a .. "+T", hl.dsp.exec_cmd("flatpak run com.rtosta.zapzap"))
hl.bind(a .. "+U", hl.dsp.exec_cmd("env QT_SCALE_FACTOR=1.5 krita"))
hl.bind(a .. "+PAGE_UP", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind(a .. "+PAGE_DOWN", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })

--> Compositor binds
hl.bind(a .. "+C", hl.dsp.window.close())
hl.bind(a .. "+F", hl.dsp.window.fullscreen())
hl.bind(b .. "+F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }))
hl.bind(a .. "+bracketright", hl.dsp.layout("togglesplit"))
hl.bind(a .. "+bracketleft",  hl.dsp.layout("swapsplit"))
hl.bind(a .. "+V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(c .. "+M", hl.dsp.exit())
hl.bind(a .. "+right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(a .. "+left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(a .. "+up", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(a .. "+down", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })
hl.bind(a .. "+mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(a .. "+mouse:273", hl.dsp.window.resize(), { mouse = true })

--> Screenshots Binds
hl.bind(a .. "+S", hl.dsp.exec_cmd("grimblast --freeze copy area"))
hl.bind(b .. "+S",
    hl.dsp.exec_cmd(
        "grimblast --freeze --filetype ppm save area - | satty --filename - --copy-command \"wl-copy\" --early-exit --fullscreen --initial-tool brush"))

--> Noctalia Binds
local function toggle_noctalia()
    local handle = io.popen(
        [[qs -c noctalia-shell ipc call state all | jq -r '.state.barVisible']]
    )

    if handle == nil then
        return
    end

    local open = handle:read("*a"):gsub("%s+$", "")
    handle:close()

    if open == "true" then
        hl.config({
            general = {
                gaps_out = 0,
            },
        })

        hl.exec_cmd("qs -c noctalia-shell ipc call bar hideBar")
    else
        hl.config({
            general = {
                gaps_out = 50,
            },
        })

        hl.exec_cmd("qs -c noctalia-shell ipc call bar showBar")
    end
end

hl.bind(a .. "+SPACE", hl.dsp.exec_cmd(noctalia .. " ipc call launcher toggle"))
hl.bind(a .. "+R", hl.dsp.exec_cmd(noctalia .. "  ipc call wallpaper random"))
hl.bind(c .. "+0", hl.dsp.exec_cmd(noctalia .. " ipc call sessionMenu toggle"))
hl.bind(a .. "+E", toggle_noctalia)

--> Workspace Binds
local function map_workspace(workspace)
    local monitors = hl.get_monitors()
    for i, m in ipairs(monitors) do
        if m.focused then
            return workspace + ((i - 1) * 10)
        end
    end
end

for i, m in ipairs(hl.get_monitors()) do
    hl.workspace_rule({ workspace = map_workspace(i), monitor = m.name, default = true })
end

for i = 1, 9 do
    hl.bind(a .. "+" .. i, function()
        hl.dispatch(hl.dsp.focus({
            workspace = map_workspace(i),
            on_current_monitor = true,
        }))
    end)

    hl.bind(b .. "+" .. i, function()
        hl.dispatch(hl.dsp.window.move({
            workspace = map_workspace(i),
            follow = false,
        }))
    end)
end

--> Scratchpad Binds
local scratchpad_apps = {
    { "signal-desktop", "signal" },
    { "vesktop", "vesktop" }
}

hl.bind(a .. "+Z", hl.dsp.workspace.toggle_special("scratchpad"))
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
    require("hyprext")
end
