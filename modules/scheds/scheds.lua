return function(lib, args)
    lib.require_field(args, "sched")
    local content = [[
type = process
command = /usr/bin/]] .. args.sched .. "\n" .. [[
restart = true
logfile = /var/log/dinit/]] .. args.sched .. [[.log
]]

    return {
        desym = {
            files = {
                ["/etc/dinit.d/" .. args.sched] = lib:root_file(content)
            }
        },
        depac = {
            packages = {
                "scx-scheds",
                "rtkit",
            }
        }
    }
end
