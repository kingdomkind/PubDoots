local pl_file = require("pl.file");

return function(lib, args)
    lib.require_field(args, "source")

    return {
        desym = {
            files = {
                ["/etc/fstab"] = lib:root_file(pl_file.read(args.source))
            }
        }
    }
end
