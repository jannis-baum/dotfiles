-- launch agent

hs.application.launchOrFocus('Synapse')

-- kindaVim notifications

kVNormalEnterWatcher = hs.distributednotifications.new(function(name, object, userInfo)
    hs.execute('/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --set-variables "{\\"kVNormal\\":1}"')
end, 'kindaVimDidEnterNormalMode')
kVNormalEnterWatcher:start()

kVNormalExitWatcher = hs.distributednotifications.new(function(name, object, userInfo)
    hs.execute('/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --set-variables "{\\"kVNormal\\":0}"')
end, 'kindaVimDidExitNormalMode')
kVNormalExitWatcher:start()
