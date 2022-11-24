local karabiner = {}

function karabiner.set(data)
    hs.execute(
        "/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --set-variables '"
        .. hs.json.encode(data) .. "'")
end

watchers = {}
function setupDNWatchers(dnTrue, dnFalse, karabinerVariable)
    watchers[#watchers + 1] = hs.distributednotifications.new(function(name, object, userInfo)
        karabiner.set({ [karabinerVariable] = 1 })
    end, dnTrue)
    watchers[#watchers]:start()

    watchers[#watchers + 1] = hs.distributednotifications.new(function(name, object, userInfo)
        karabiner.set({ [karabinerVariable] = 0 })
    end, dnFalse)
    watchers[#watchers]:start()

end

setupDNWatchers('kindaVimDidEnterNormalMode', 'kindaVimDidExitNormalMode', 'kVNormal')
setupDNWatchers('WooshyInputDidAppear', 'WooshyInputDidDisappear', 'inWooshy')
setupDNWatchers('ScrollaDidEngage', 'ScrollaDidDisengage', 'inScrolla')

return karabiner
