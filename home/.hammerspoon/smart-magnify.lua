-- smart magnify
-- couldn't figure out how to construct a working smart magnify event with
-- hammerspoon... so i used this:
--
local base64 = require"base64"
-- gestureWatcher = hs.eventtap.new( { hs.eventtap.event.types.gesture }, function(e)
--     if e:getType(true) == hs.eventtap.event.types.smartMagnify then
--         hs.printf(base64.encode(e:asData()))
--     end
-- end)
-- gestureWatcher:start()
--
-- ...to get the base64 encoded binary data of a captured event it, hard code it
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
