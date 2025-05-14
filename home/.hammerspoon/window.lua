-- AXEnhancedUserInterface setting breaks window moving & resizing so we
-- disable and then reset it to do these actions on windows
-- (https://github.com/Hammerspoon/hammerspoon/issues/3224#issuecomment-1294359070)
local function ax_enhanced_workaround(app, action)
    local ax_app = hs.axuielement.applicationElement(app)

    -- original settings
    local was_enhanced = ax_app.AXEnhancedUserInterface
    local original_animation_duration = hs.window.animationDuration

    -- set & run action
    ax_app.AXEnhancedUserInterface = false
    hs.window.animationDuration = 0
    action()

    -- restore original settings
    hs.window.animationDuration = original_animation_duration
    ax_app.AXEnhancedUserInterface = was_enhanced
end

-- fit window below sketchybar on external displays
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
    ax_enhanced_workaround(window:application(), function()
        window:setFrame({
            x = win_frame.x, y = win_frame.y + overlap,
            w = win_frame.w, h = win_frame.h - overlap
        }, 0)
    end)
end

hs.urlevent.bind('fitWinBelowSketchybar', function(eventName, params)
    fit_win_below_sketchybar(hs.window.focusedWindow())
end)
