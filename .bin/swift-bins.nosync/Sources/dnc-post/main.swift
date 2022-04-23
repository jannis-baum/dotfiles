import Foundation

func printUsage() {
    print("usage: \(CommandLine.arguments[0]) notification-name")
}

guard let notificationName = CommandLine.arguments[safe: 1] else { printUsage(); exit(EXIT_FAILURE) }

DistributedNotificationCenter.default().postNotificationName(NSNotification.Name(notificationName), object: nil, userInfo: nil, deliverImmediately: true)

public extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

