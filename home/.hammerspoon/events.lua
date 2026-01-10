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
