-- launch
hs.execute('open -g -a Synapse')

-- control center sink
local modifierLookup = {
    ['S'] = 'shift',
    ['C'] = 'command',
    ['O'] = 'alt',
    ['A'] = 'alt',
    ['T'] = 'control',
    ['F'] = 'fn'
}
local fnLookup = {
    ['systemKey'] = function(key)
        hs.eventtap.event.newSystemKeyEvent(key, true):post()
        hs.eventtap.event.newSystemKeyEvent(key, false):post()
    end,
    ['key'] = function (key)
        local mods = {}
        for c in key:gmatch('%u') do
            local mod = modifierLookup[c]
            if (mod) then table.insert(mods, mod) end
        end
        local k = key:match('[%l%d]')
        if (k) then
            hs.eventtap.event.newKeyEvent(mods, k, true):post()
            hs.eventtap.event.newKeyEvent(mods, k, false):post()
        end
    end,
    ['sleep'] = function(a) hs.caffeinate.systemSleep() end,
    ['reboot'] = function(a) hs.caffeinate.restartSystem() end,
    ['shutdown'] = function(a) hs.caffeinate.shutdownSystem() end
}
hs.urlevent.bind('controlCenter', function(eventName, params)
    local info = params['info']
    if info == nil then
        return
    end

    for k, v in info:gmatch('([%w_-]+):([%w_-]+)') do
        local fn = fnLookup[k]
        if (fn) then fn(v) end
     end
end)
