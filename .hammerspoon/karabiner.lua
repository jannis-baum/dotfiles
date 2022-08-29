local karabiner = {}

function karabiner.set(data)
    hs.execute(
        "/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --set-variables '"
        .. hs.json.encode(data) .. "'")
end

return karabiner
