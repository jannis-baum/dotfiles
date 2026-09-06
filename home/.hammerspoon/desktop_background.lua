hs.urlevent.bind('update-desktop-backgrounds', function(eventName, params)
    local base_image = string.format("%s/_/backgrounds/background", os.getenv("HOME"))
    -- ls source image to check that it exists, otherwise status of ls as last
    -- command will be nil
    hs.execute(string.format("rm -f %s_*", base_image))
    local source_image, status = hs.execute(string.format("ls %s.* | head -1", base_image))
    -- strip trailing whitespace (newline)
    source_image = source_image:gsub("%s+$", "")
    if status == nil then return end

    for _, screen in ipairs(hs.screen.allScreens()) do
        local info = screen:currentMode()
        -- add UUID to image name so that the OS realizes it's a different file
        -- than before
        local dest_image = string.format("%s_%sx%ss%s_%s.png", base_image, info["w"], info["h"], info["scale"], hs.host.uuid())

        hs.execute(string.format(
            "~/.local/bin/create-desktop-image %s %s %s %s %s 2>/Users/jannisbaum/Desktop/debug.txt",
            source_image, info["w"], info["h"], info["scale"], dest_image
        ))
        -- set actual background
        screen:desktopImageURL(string.format("file://%s", dest_image))
    end
end)
