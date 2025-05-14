hs.window.animationDuration = 0 -- does nothing

local sketchybar_height = 32
local function fit_win_below_sketchybar(window)
    local screen = window:screen()
    -- ignore built-in display, fits because of notch
    if string.find(screen:name(), 'Built%-in') then
        return
    end
    local win_frame = window:frame()
    -- overlap with sketchybar
    local overlap = screen:frame().y + sketchybar_height - win_frame.y
    if overlap <= 0 then
        return
    end
    -- horrible hack to move & resize window
    -- https://github.com/Hammerspoon/hammerspoon/issues/3731
    window:setSize({ w = win_frame.w, h = win_frame.h - overlap })
    os.execute('sleep 0.25')
    window:setTopLeft({ x = win_frame.x, y = win_frame.y + overlap })
end

hs.urlevent.bind('fitWinBelowSketchybar', function(eventName, params)
    fit_win_below_sketchybar(hs.window.focusedWindow())
end)
