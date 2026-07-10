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

    lib.merge(base, {
        desym = {
            files = {
                ["/etc/mkinitcpio.conf"] = lib:root_file(content),
            }
        },
    })

    return base
end
