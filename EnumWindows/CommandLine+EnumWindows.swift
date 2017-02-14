import Foundation

extension CommandLine {
    static func searchQuery() -> String {
        return CommandLine.arguments.suffix(from: 1).joined(separator: " ")
    }
}
