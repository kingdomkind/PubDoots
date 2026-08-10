return function(lib)
    local content = [[
#!/bin/sh

GETTY_BAUD=38400
GETTY_TERM=linux
GETTY_ARGS="--autologin ]] .. lib.user .. [["
]]

    return {
        desym = {
            files = {
                ["/etc/dinit.d/config/agetty-tty1.conf"] = lib:root_file(content)
            }
        }
    }
end
