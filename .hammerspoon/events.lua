local e = {}


--------------------------------------------------------------------------------
-- reload config ---------------------------------------------------------------
hs.urlevent.bind("reloadConfig", function(eventName, params)
    hs.reload()
end)


--------------------------------------------------------------------------------
-- apps ------------------------------------------------------------------------
e.safariWatcher = hs.application.watcher.new(function(name, eventType, app)
    if name == 'Safari' and eventType == hs.application.watcher.terminated then
        out, status = hs.execute('~/.bin/cookie-cleaner ~/.safari/cookie-whitelist.txt')
    end
end)
e.safariWatcher:start()


--------------------------------------------------------------------------------
-- distributed notifications ---------------------------------------------------
e.dnWatchers = {}
function e.setupDNWatcher(dn, callback)
    e.dnWatchers[#e.dnWatchers + 1] = hs.distributednotifications.new(function(name, object, userInfo)
        callback()
    end, dn)
    e.dnWatchers[#e.dnWatchers]:start()
end


--------------------------------------------------------------------------------
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


--------------------------------------------------------------------------------
-- wooshy ----------------------------------------------------------------------
hs.urlevent.bind('mouseToMenubar', function()
    event = hs.eventtap.event.newEvent()
    event:setType(hs.eventtap.event.types.mouseMoved)
    event:location({ x=100, y=0 })
    event:post()
end)

e.setupDNWatcher('WooshyInputDidDisappear', function()
    pos = hs.mouse.getAbsolutePosition()
    if pos.y < 24 then
        event = hs.eventtap.event.newEvent()
        event:setType(hs.eventtap.event.types.mouseMoved)
        event:location({ x=pos.x, y=pos.y + 100 })
        event:post()
    end
end)


return e
