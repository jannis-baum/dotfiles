import AppKit

func printUsage() {
    print("usage: \(CommandLine.arguments[0]) <matching | mismatching> <PID> <active | hidden>")
}

let args = CommandLine.arguments
guard args.count == 4,
    let pid = Int(args[2]),
    let matching = ["mismatching", "matching"].firstIndex(of: args[1]),
    let kitty = matching == 1
        ? NSRunningApplication(processIdentifier: Int32(pid))
        : NSWorkspace.shared.runningApplications.first(where: { $0.localizedName == "kitty" && $0.processIdentifier != Int32(pid) }),
    let hidden = ["active", "hidden"].firstIndex(of: args[3])
else {
    printUsage()
    exit(EXIT_FAILURE)
}

if hidden == 1 {
    let axKitty = AXUIElementCreateApplication(kitty.processIdentifier)
    AXUIElementSetAttributeValue(axKitty, kAXHiddenAttribute as CFString, kCFBooleanTrue)
} else {
    print(kitty.activate(options: [.activateAllWindows, .activateIgnoringOtherApps]))
}
