local e = {}

-- reload config ---------------------------------------------------------------
hs.urlevent.bind("reload-config", function(eventName, params)
    hs.reload()
end)

-- apps ------------------------------------------------------------------------
e.appWatcher = hs.application.watcher.new(function(name, eventType, app)
    if name == 'kitty' and eventType == hs.application.watcher.deactivated then
        for _, window in ipairs(app:visibleWindows()) do
            local screen = window:screen()
            local frame = window:frame()
            if frame ~= screen:frame() then
                return
            end
        end
        app:hide()
    end
end)
e.appWatcher:start()

-- hide sketchybar to show vanilla menu bar until mouse is moved down ----------
hs.urlevent.bind("sketchy-menubar", function()
    if e.sketchyMenubarWatcher ~= nil then return end

    hs.execute([[/opt/homebrew/bin/sketchybar --bar hidden=on]])
    e.sketchyMenubarWatcher = hs.eventtap.new({ hs.eventtap.event.types.mouseMoved }, function(event)
        if event:location().y >= 40 then
            hs.execute([[/opt/homebrew/bin/sketchybar --bar hidden=off]])
            e.sketchyMenubarWatcher:stop()
            e.sketchyMenubarWatcher = nil
        end
    end)
    e.sketchyMenubarWatcher:start()
end)

-- distributed notifications ---------------------------------------------------
e.dnWatchers = {}
function e.setupDNWatcher(dn, callback)
    e.dnWatchers[#e.dnWatchers + 1] = hs.distributednotifications.new(function(name, object, userInfo)
        callback()
    end, dn)
    e.dnWatchers[#e.dnWatchers]:start()
end

-- dark/light mode -------------------------------------------------------------
e.setupDNWatcher('AppleInterfaceThemeChangedNotification', function()
    os.execute(os.getenv('HOME') .. '/.config/kitty/scripts/sync-theme')
end)

return e
