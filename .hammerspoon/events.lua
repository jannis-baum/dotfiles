-- reload config
hs.urlevent.bind("reloadConfig", function(eventName, params)
    hs.reload()
end)

-- sleep
sleepWatcher = hs.caffeinate.watcher.new(function(event)
    if event == hs.caffeinate.watcher.systemWillSleep then
        hs.execute('~/_lib/cookie-cleaner/.build/release/cookie-cleaner ~/_lib/cookie-cleaner/whitelist.txt')
    end
end)
sleepWatcher:start()
