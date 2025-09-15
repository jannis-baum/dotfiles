local e = {}

-- reload config ---------------------------------------------------------------
hs.urlevent.bind("reloadConfig", function(eventName, params)
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

-- karabiner -------------------------------------------------------------------
function e.karabinerSet(data)
    hs.execute(
        "/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --set-variables '"
        .. hs.json.encode(data) .. "'")
end

function e.setupKarabinerDNs(dnTrue, dnFalse, karabinerVariable)
    e.setupDNWatcher(dnTrue, function() e.karabinerSet({ [karabinerVariable] = 1 }) end)
    e.setupDNWatcher(dnFalse, function() e.karabinerSet({ [karabinerVariable] = 0 }) end)
end

e.setupKarabinerDNs('kindaVimDidEnterNormalMode', 'kindaVimDidExitNormalMode', 'kVNormal')
e.setupKarabinerDNs('WooshyInputDidAppear', 'WooshyInputDidDisappear', 'inWooshy')
e.setupKarabinerDNs('ScrollaDidEngage', 'ScrollaDidDisengage', 'inScrolla')

-- wooshy ----------------------------------------------------------------------
hs.urlevent.bind('showMenubar', function()
    pos = hs.mouse.absolutePosition()
    event = hs.eventtap.event.newEvent()
    event:setType(hs.eventtap.event.types.mouseMoved)
    event:location({ x=pos.x, y=0 })
    event:post()
end)

hs.urlevent.bind('hideMenubar', function()
    pos = hs.mouse.absolutePosition()
    if pos.y > 24 then return end

    event = hs.eventtap.event.newEvent()
    event:setType(hs.eventtap.event.types.mouseMoved)
    event:location({ x=pos.x, y=pos.y + 100 })
    event:post()
end)

-- dark/light mode -------------------------------------------------------------
e.setupDNWatcher('AppleInterfaceThemeChangedNotification', function()
    os.execute(os.getenv('HOME') .. '/.config/kitty/scripts/sync-theme')
end)

return e
