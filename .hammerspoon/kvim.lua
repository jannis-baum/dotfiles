local karabiner = require"karabiner"
function setkVNormal(value)
    karabiner.set({ ['kVNormal'] = value })
end

kVNormalEnterWatcher = hs.distributednotifications.new(function(name, object, userInfo)
    setkVNormal(1)
end, 'kindaVimDidEnterNormalMode')
kVNormalEnterWatcher:start()

kVNormalExitWatcher = hs.distributednotifications.new(function(name, object, userInfo)
    setkVNormal(0)
end, 'kindaVimDidExitNormalMode')
kVNormalExitWatcher:start()
