-- reload config

hs.urlevent.bind("reloadConfig", function(eventName, params)
    hs.reload()
end)


-- launch agent

hs.execute('open -g -a Synapse')


-- kindaVim notifications

kVNormalEnterWatcher = hs.distributednotifications.new(function(name, object, userInfo)
    hs.execute('/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --set-variables "{\\"kVNormal\\":1}"')
end, 'kindaVimDidEnterNormalMode')
kVNormalEnterWatcher:start()

kVNormalExitWatcher = hs.distributednotifications.new(function(name, object, userInfo)
    hs.execute('/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --set-variables "{\\"kVNormal\\":0}"')
end, 'kindaVimDidExitNormalMode')
kVNormalExitWatcher:start()


-- sleep events

sleepWatcher = hs.caffeinate.watcher.new(function(event)
    if event == hs.caffeinate.watcher.systemWillSleep then
        hs.execute('~/_lib/cookie-cleaner/.build/release/cookie-cleaner ~/_lib/cookie-cleaner/whitelist.txt')
    end
end)
sleepWatcher:start()

-- smart magnify
-- couldn't figure out how to construct a working smart magnify event with
-- hammerspoon... so i used this
--
local base64 = require"base64"
-- gestureWatcher = hs.eventtap.new( { hs.eventtap.event.types.gesture }, function(e)
--     if e:getType(true) == hs.eventtap.event.types.smartMagnify then
--         hs.printf(base64.encode(e:asData()))
--     end
-- end)
-- gestureWatcher:start()
--
-- to get the base64 encoded binary data of a captured event it, hard code it
-- data here and decode it again
--
local smartMagnifyData = base64.decode( "AAAAAgABQDUAAAADAAFANgAAAAAAAUA3AAAAHQACwDhEWMRHRAPYFgACwDkAAAAAAAAAAAABADqGuilxAABGZQABQDsAAAAAAAFAMwAAAAAAAUA0AAAAAAABAKmGsxI9AABGZQABQGoAAAAAAAFAawAABaAALBBtPRKzhmVGAACGLwEAAQAAAAAAAAAAAAAAAQAAABAAAAAWAAAAAAAAAAAAAAAAAUBuAAAAFgABQG8AAAAAAAFAcAAAAAAAAUCEAAAAAAABQIUAAAAA")
--
-- to construct a working event...
hs.urlevent.bind("smartMagnify", function(eventName, params)
    local event = hs.eventtap.event.newEventFromData(smartMagnifyData)
    event:location(hs.mouse.absolutePosition())
    event:post()
end)
