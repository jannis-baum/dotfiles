function Type(input, delay)
    if #input == 0 then return end
    if delay == nil then delay = 30 end
    local char = input:sub(1, 1)
    hs.eventtap.keyStroke({}, char, 0)
    hs.timer.doAfter(delay / 1000, function()
        Type(input:sub(2), delay)
    end)
end
