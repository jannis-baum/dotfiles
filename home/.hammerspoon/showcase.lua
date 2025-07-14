-- typing ----------------------------------------------------------------------
--
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

local function type(input, next)
    if #input == 0 then
        next()
        return
    end

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
    hs.timer.doAfter(0.03, function()
        type(input:sub(2), next)
    end)
end


-- delays ----------------------------------------------------------------------
--
local function delay(input, next)
    hs.timer.doAfter(tonumber(input), next)
end

-- commands & input file processing --------------------------------------------
--
local commands = {
    ["type"] = type,
    ["delay"] = delay,
}

local function process_lines(lines)
    local line = lines[1]
    if line == nil then
        return
    end
    table.remove(lines, 1)
    next = function() process_lines(lines) end

    if line:sub(1, 1) == "#" then
        next()
        return
    end

    local command, arguments = line:match("^(%w[%w%-_]*):%s(.+)$")
    if command == nil then
        hs.printf("Incorrect format: " .. line)
        return
    end
    if commands[command] ~= nil then
        commands[command](arguments, next)
    else
        hs.printf("Unknown command: " .. command)
        return
    end
end

function RunShowcase(showcase_file)
    local lines = {}
    for line in io.lines(showcase_file) do
        table.insert(lines, line)
    end
    process_lines(lines)
end
