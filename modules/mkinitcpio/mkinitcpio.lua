local pl_file = require("pl.file");

return function(lib, args)
    local base = {
        depac = {
            packages = {
                "mkinitcpio",
            }
        }
    }

    lib.require_field(args, "source")
    local content = pl_file.read(args.source)
    local files = {
        ["/etc/mkinitcpio.conf"] = lib:root_file(content),
    }

    if args.custom then
        for _, hook in ipairs(args.custom) do
            local hook_source = lib.cwd() .. hook
            local hook_content = pl_file.read(hook_source)
            --> Hook is optional
            if hook_content then
                files["/etc/initcpio/hooks/" .. hook] = lib:root_file(hook_content)
            end

            local install_source = hook_source .. ".install"
            local install_content = pl_file.read(install_source)
            if not install_content then
                error("[EXIT] Custom install hook didn't exist: " .. install_source)
            end

            files["/etc/initcpio/install/" .. hook] = lib:root_file(install_content)
        end
    end

    lib.merge(base, {
        desym = {
            files = files
        },
    })

    return base
end
