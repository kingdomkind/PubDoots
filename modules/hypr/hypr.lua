return function(lib, args)
    local base = {
        desym = {
            symlinks = {
                [lib.configd.. "hypr/hyprland.lua"] = { source = lib.cwd().. "hyprland.lua" }
            }
        }
    }

    if args ~= nil then
        lib.merge(base, {
            desym = {
                symlinks = {
                    [lib.configd.. "hypr/hyprext.lua"] = { source = args.extension }
                }
            }
        })
    end

    return base
end
