return function(hostname)
    local patch = {}
    patch.configd = "/home/pika/.config/"
    patch.homed = "/home/pika/"
    patch.dootsd = "./"
    patch.uniqued = "unique/" .. hostname .. "/"
    patch.modulesd = "modules/"
    patch.uid = 1000
    patch.gid = 1000
    patch.user = "pika"
    patch.mode = tonumber("644", 8)

    function patch:root_file(content)
        return
        {
            source = content,
            uid = 0,
            gid = 0,
            mode = tonumber("644", 8)
        }
    end

    function patch:root_binary(content)
        return
        {
            source = content,
            uid = 0,
            gid = 0,
            mode = tonumber("755", 8)
        }
    end

    function patch:user_file(content)
        return
        {
            source = content,
            uid = self.uid,
            gid = self.gid,
            mode = tonumber("644", 8),
        }
    end

    return patch
end
