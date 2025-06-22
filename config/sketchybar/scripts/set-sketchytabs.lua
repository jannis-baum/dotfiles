local function assert_non_nil(value)
    if value == nil then
        print('usage: ' .. arg[0] .. ' APP')
        print('Tabs are read from stdin as `[active]:[image-path]:tab title`')
        os.exit(1)
    end
end

local function get_current_app()
    local osascript = io.popen('osascript -l JavaScript -e \'ObjC.import("AppKit");$.NSWorkspace.sharedWorkspace.frontmostApplication.localizedName\'')
    if osascript == nil then return nil end
    local app, _ = osascript:read('*a'):gsub('%s+', '')
    return app
end

local function ellipse_string(s, max_length)
    if max_length == 0 then return '' end

    s = s:gsub('^%s+' ,''):gsub('%s+$', '')
    if s:len() <= max_length then return s end

    if max_length > 10 then
        local result, _ = s:sub(1, max_length - 1):gsub('%s+$', '')
        return result .. '…'
    end

    local result, _ = s:sub(1, max_length):gsub('%s+$', '')
    return result
end

local function get_widths(tab_count)
    local bar_w = 647 -- check with screenshot tool cmd+shift+4, subtract 1 for rounding errors
    -- read dimension data
    local widths = {}
    for line in io.lines(os.getenv('HOME') .. '/.local/state/sketchybar/widths.txt') do
        local key, value = line:match('([^:]+)=(.+)')
        widths[key] = value
    end

    local base = widths['base'] * tab_count
    local free_space = bar_w - base
    -- free_space = (tab_count - 1) * inactive + active
    -- free_space = (tab_count - 1) * inactive + 3 * inactive
    -- free_space = inactive * (tab_count - 1 + 3)
    -- free_space = inactive * (tab_count + 2)
    -- inactive = free_space / (tab_count + 2) -> floor & max(0, _)
    widths['inactive'] = math.max(0, math.floor(free_space / (tab_count + 2)))
    widths['active'] = math.max(0, math.floor(free_space - widths['inactive'] * (tab_count - 1)))
    return widths
end

local function main()
    local tab_app = arg[1]
    assert_non_nil(tab_app)

    local current_app = get_current_app()
    if current_app == nil then return end

    local sketchy_cmd = 'sketchybar --remove "/APP-' .. tab_app .. '\\d*/"'
    local drawing = arg[1] == current_app and 'on' or 'off'

    local lines = io.read('*a')
    local _, tab_count = lines:gsub('\n', '')
    local widths = get_widths(tab_count)

    local line_num = 1
    for line in lines:gmatch('[^\n]+') do
        local is_active, image, label = line:match('([^:]*):([^:]*):(.*)')
        assert_non_nil(is_active)
        assert_non_nil(image)
        assert_non_nil(label)

        -- only allow alphanumeric (%w), punctuation (%p) and spaces (%s)
        -- because lua doesn't understand utf8
        label, _ = label:gsub('[^%w%p%s]', '')
        -- replace consecutive spaces with a single space
        label, _ = label:gsub('%s%s+', ' ')

        local item_name = 'APP-' .. tab_app .. '-' .. tostring(line_num)
        local label_color = (is_active ~= '') and '0xffbbbbbb' or '0xff808080'

        local max_title_w = (is_active ~= '') and widths['active'] or widths['inactive']
        if image ~= '' then
            max_title_w = max_title_w - widths['image']
        end
        label = ellipse_string(label, math.floor(max_title_w / widths['char']))

        sketchy_cmd = sketchy_cmd
            .. ' --add item "' .. item_name .. '" left'
            .. ' --set "' .. item_name .. '"'
                .. ' script=~/.config/sketchybar/plugins/sketchytab.zsh'
                .. ' drawing=' .. drawing
                .. ' label="' .. label .. '"'
                .. ' label.font=Menlo:Bold:14'
                .. ' label.color=' .. label_color
            .. ' --subscribe "' .. item_name .. '" front_app_switched'

        if image ~= '' then
            sketchy_cmd = sketchy_cmd .. ' --set "' .. item_name .. '"'
                .. ' background.drawing=on background.image.drawing=on'
                .. ' icon.padding_left=8'
                .. ' background.padding_left=8'
                .. ' background.image.string="' .. image .. '"'
                .. ' background.image.scale=0.5'
        end

        line_num = line_num + 1
    end

    local _, _, code = os.execute(sketchy_cmd)
    return code
end

return main()
