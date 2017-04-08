import Foundation

protocol CommmandLineCommand {
    static func fromArgv(argv : String) -> CommmandLineCommand?
    static var name : String { get }
    init(value: String)
}

extension CommmandLineCommand {
    static func fromArgv(argv : String) -> CommmandLineCommand? {
        let prefix = "\(self.name)="
        guard argv.hasPrefix(prefix) else {
            return nil
        }
        let query = argv
            .replacingOccurrences(of: prefix, with: "")
            .replacingOccurrences(of: "\"", with: "")
        
        return self.init(value: query)
    }
}

struct OnlyTabsCommand : CommmandLineCommand {
    internal static var name: String { return "--search-tabs" }
    
    let query : String;
    
    init(value: String) {
        self.query = value
    }
}

struct SearchCommand : CommmandLineCommand {
    internal static var name: String { return "--search" }

    let query : String;
    
    init(value: String) {
        self.query = value
    }
}

extension CommandLine {
    
    static func commands() -> [CommmandLineCommand] {
        var result : [CommmandLineCommand?] = []
        for arg in self.arguments {
            result.append(SearchCommand.fromArgv(argv: arg))
            result.append(OnlyTabsCommand.fromArgv(argv: arg))
        }
        return result.flatMap { (command: CommmandLineCommand?) -> [CommmandLineCommand] in
            guard let c = command else { return [] }
            return [c]
        }
    }
}
