-- reload config

hs.urlevent.bind("reloadConfig", function(eventName, params)
    hs.reload()
end)


-- launch agent

hs.execute('open -g -a Synapse')


-- kindaVim notifications

kVNormalEnterWatcher = hs.distributednotifications.new(function(name, object, userInfo)
    hs.execute('/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --set-variables "{\\"kVNormal\\":1}"')
end, 'kindaVimDidEnterNormalMode')
kVNormalEnterWatcher:start()

kVNormalExitWatcher = hs.distributednotifications.new(function(name, object, userInfo)
    hs.execute('/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --set-variables "{\\"kVNormal\\":0}"')
end, 'kindaVimDidExitNormalMode')
kVNormalExitWatcher:start()


-- sleep events

sleepWatcher = hs.caffeinate.watcher.new(function(event)
    if event == hs.caffeinate.watcher.systemWillSleep then
        hs.execute('~/_lib/cookie-cleaner/.build/release/cookie-cleaner ~/_lib/cookie-cleaner/whitelist.txt')
    end
end)
sleepWatcher:start()
