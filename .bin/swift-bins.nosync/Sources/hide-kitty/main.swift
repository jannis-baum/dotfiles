import AppKit

if let kitty = NSWorkspace.shared.runningApplications.first(where: { $0.localizedName == "kitty" }) {
    let axKitty = AXUIElementCreateApplication(kitty.processIdentifier)
    AXUIElementSetAttributeValue(axKitty, kAXHiddenAttribute as CFString, kCFBooleanTrue)
}

