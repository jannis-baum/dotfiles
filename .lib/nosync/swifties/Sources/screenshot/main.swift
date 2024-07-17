import AppKit

func fail(_ reason: String? = nil) {
    if let reason = reason {
        print(reason)
    }
    print("usage: \(CommandLine.arguments[0]) target")
    exit(EXIT_FAILURE)
}

extension Data {
    func write(to path: String) throws {
        let expanded = (path as NSString).expandingTildeInPath
        let absolute = expanded.hasPrefix("/")
            ? expanded
            : (FileManager.default.currentDirectoryPath as NSString).appendingPathComponent(expanded)
        let url = URL(fileURLWithPath: absolute)

        // create any necessary directories in the path
        let dir = url.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)

        try self.write(to: url)
    }
}

func takeScreenshot() {
    let fourKey: CGKeyCode = 21
    let source = CGEventSource(stateID: .hidSystemState)

    // Key Down Event
    let keyDown = CGEvent(keyboardEventSource: source, virtualKey: fourKey, keyDown: true)
    keyDown?.flags = [.maskCommand, .maskShift, .maskControl]
    keyDown?.post(tap: .cghidEventTap)

    // Key Up Event
    let keyUp = CGEvent(keyboardEventSource: source, virtualKey: fourKey, keyDown: false)
    keyUp?.post(tap: .cghidEventTap)
}

func main() {
    guard CommandLine.arguments.count == 2 else {
        fail()
        return
    }
    let target = CommandLine.arguments[1]
    takeScreenshot()

    let pasteboard = NSPasteboard.general

    var imageData: Data?
    var count = 0
    repeat {
        if count > 0 {
            usleep(UInt32(500e3))
        }
        imageData = pasteboard.pasteboardItems?.compactMap({ $0.data(forType: .png) }).first
        count += 1
    } while imageData == nil && count < 120

    guard let imageData = imageData else {
        fail("Timed out without PNG data in the clipboard")
        return
    }
    do {
        try imageData.write(to: target)
    } catch { fail("Unable to write PNG data to \(target)") }
}

main()
