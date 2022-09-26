-- launch
hs.execute('open -g -a Synapse')

-- system key sink
hs.urlevent.bind("systemKey", function(eventName, params)
    local key = params['key']
    if key == nil then
        return
    end
    hs.eventtap.event.newSystemKeyEvent(key, true):post()
    hs.eventtap.event.newSystemKeyEvent(key, false):post()
end)
