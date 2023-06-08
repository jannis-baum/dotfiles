-- reload config
hs.urlevent.bind("reloadConfig", function(eventName, params)
    hs.reload()
end)

-- apps
safariWatcher = hs.application.watcher.new(function(name, eventType, app)
    if name == 'Safari' and eventType == hs.application.watcher.terminated then
        out, status = hs.execute('~/_lib/cookie-cleaner/.build/release/cookie-cleaner ~/.safari/cookie-whitelist.txt')
    end
end)
safariWatcher:start()
