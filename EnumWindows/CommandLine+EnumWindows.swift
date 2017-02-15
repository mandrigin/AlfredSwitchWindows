import Foundation

protocol CommmandLineCommand {
    static func fromArgv(argv : String) -> CommmandLineCommand?
}

struct SearchCommand : CommmandLineCommand {
    let query : String;
    
    init(query: String) {
        self.query = query
    }
    
    static func fromArgv(argv: String) -> CommmandLineCommand? {
        let prefix = "--search="
        guard argv.hasPrefix(prefix) else {
            return nil
        }
        let query = argv
            .replacingOccurrences(of: prefix, with: "")
            .replacingOccurrences(of: "\"", with: "")
        
        return SearchCommand(query: query)
    }
}

extension CommandLine {
    
    static func commands() -> [CommmandLineCommand] {
        var result : [CommmandLineCommand] = []
        for arg in self.arguments {
            guard let c = SearchCommand.fromArgv(argv: arg) else {
                continue
            }
            result.append(c)
        }
        return result
    }
}
