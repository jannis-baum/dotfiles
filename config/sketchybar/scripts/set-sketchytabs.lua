local function get_current_app()
    local osascript = io.popen('osascript -l JavaScript -e \'ObjC.import("AppKit");$.NSWorkspace.sharedWorkspace.frontmostApplication.localizedName\'')
    if osascript == nil then return nil end
    local app, _ = osascript:read('*a'):gsub('%s+', '')
    return app
end

local function assert_non_nil(value)
    if value == nil then
        print('usage: ' .. arg[0] .. ' APP')
        print('Tabs are read from stdin as `[active]:[image-path]:tab title`')
        os.exit(1)
    end
end

local function main()
    local tab_app = arg[1]
    assert_non_nil(tab_app)

    local current_app = get_current_app()
    if current_app == nil then return end

    local sketchy_cmd = 'sketchybar --remove "/APP-' .. tab_app .. '\\d*/"'
    local drawing = arg[1] == current_app and 'on' or 'off'

    local line_num = 1
    for line in io.read('*a'):gmatch('[^\n]+') do
        local is_active, image, label = line:match('([^:]*):([^:]*):(.*)')
        assert_non_nil(is_active)
        assert_non_nil(image)
        assert_non_nil(label)

        local item_name = 'APP-' .. tab_app .. '-' .. tostring(line_num)
        local label_color = (is_active ~= '') and '0xffbbbbbb' or '0xff808080'

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
