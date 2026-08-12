return function(lib, args)
    local base = {
        desym = {
            symlinks = {
                [lib.configd .. "hypr/hyprland.lua"] = { source = lib.cwd() .. "hyprland.lua" }
            },
        },
        depac = {
            packages = {
                "hyprland",
                "hyprpolkitagent",
                "xdg-desktop-portal-hyprland",
                "satty",
                "hyprpicker",
                "wl-clipboard",
                "noctalia",
                "brave-origin-bin",
                "grimblast",
            },
            ignore = {
                "rose-pine-hyprcursor",
                "grimblast-git",
            }
        }
    }

    lib.require_field(args, "extension")
    lib.merge(base, {
        desym = {
            symlinks = {
                [lib.configd .. "hypr/hyprext.lua"] = { source = args.extension }
            }
        },
    })

    return base
end
