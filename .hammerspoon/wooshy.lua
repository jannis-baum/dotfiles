local karabiner = require"karabiner"
function setInWooshy(value)
    karabiner.set({ ['inWooshy'] = value })
end

wooshyAppearWatcher = hs.distributednotifications.new(function(name, object, userInfo)
    setInWooshy(1)
end, 'WooshyInputDidAppear')
wooshyAppearWatcher:start()

wooshyDisappearWatcher = hs.distributednotifications.new(function(name, object, userInfo)
    setInWooshy(0)
end, 'WooshyInputDidDisappear')
wooshyDisappearWatcher:start()
