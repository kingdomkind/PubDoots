return function(lib, args)
    local base = {
        desym = {
            symlinks = {
                [lib.configd.. "hypr/hyprland.lua"] = { source = lib.cwd().. "base.lua" }
            }
        }
    }

    if args ~= nil then
        lib.merge(base, {
            desym = {
                symlinks = {
                    [lib.configd.. "hypr/hyprext.lua"] = { source = args[1] }
                }
            }
        })
    end

    return base
end
