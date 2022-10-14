-- launch
hs.execute('open -g -a Synapse')

-- control center sink
local fnLookup = {
    ['systemKey'] = function(key)
        hs.eventtap.event.newSystemKeyEvent(key, true):post()
        hs.eventtap.event.newSystemKeyEvent(key, false):post()
    end
}
hs.urlevent.bind("controlCenter", function(eventName, params)
    local info = params['info']
    if info == nil then
        return
    end

    for k, v in string.gmatch(info, "([%w_-]+):([%w_-]+)") do
        local fn = fnLookup[k]
        if (fn) then fn(v) end
     end
end)
