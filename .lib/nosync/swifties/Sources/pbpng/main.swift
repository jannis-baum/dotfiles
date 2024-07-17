import AppKit

func fail() {
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

func main() {
    guard CommandLine.arguments.count == 2 else {
        fail()
        return
    }
    let target = CommandLine.arguments[1]

    let pasteboard = NSPasteboard.general

    guard let imageData = pasteboard.pasteboardItems?.compactMap({ $0.data(forType: .png) }).first
    else {
        print("No PNG found in clipboard")
        return
    }

    do {
        try imageData.write(to: target)
    } catch { fail() }
}

main()
