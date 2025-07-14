local shift_keys = {
    -- number row
    ["~"] = "`", ["!"] = "1", ["@"] = "2", ["#"] = "3", ["$"] = "4",
    ["%"] = "5", ["^"] = "6", ["&"] = "7", ["*"] = "8", ["("] = "9",
    [")"] = "0", ["_"] = "-", ["+"] = "=",
    -- upper row
    ["{"] = "[", ["}"] = "]", ["|"] = "\\",
    -- home row
    [":"] = ";", ["\""] = "'",
    -- lower row
    ["<"] = ",", [">"] = ".", ["?"] = "/",
}
for c in string.gmatch("abcdefghijklmnopqrstuvwxyz", ".") do
    shift_keys[c:upper()] = c
end

local named_keys = {
    [" "] = "space"
}

function Type(input, delay)
    if #input == 0 then return end
    if delay == nil then delay = 30 end
    local char = input:sub(1, 1)
    local mods = {}
    if shift_keys[char] ~= nil then
        char = shift_keys[char]
        mods = {"shift"}
    end
    if named_keys[char] ~= nil then
        char = named_keys[char]
    end
    hs.eventtap.keyStroke(mods, char, 0)
    hs.timer.doAfter(delay / 1000, function()
        Type(input:sub(2), delay)
    end)
end
