return function(lib)
    return {
        desym = {
            symlinks = {
                [lib.configd .. "glide/glide.ts"] = { source = lib.cwd() .. "glide.ts" }
            }
        },
        depac = {
            pkgbuilds = {
                "glide-browser-bin",
            },
        }
    }
end
