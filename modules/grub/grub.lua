local pl_file = require("pl.file");

return function(lib, args)
    local base = {
        depac = {
            packages = {
                "grub",
            }
        }
    }

    lib.require_field(args, "source")
    local content = pl_file.read(args.source)

    lib.merge(base, {
        desym = {
            files = {
                ["/etc/default/grub"] = {
                    source = content,
                    uid = lib.uid,
                    gid = lib.gid,
                    mode = lib.mode,

                }
            }
        },
    })

    return base
end
