import Foundation


func searchWindowsExceptSafari(query: String) -> [AlfredItem] {
    return Windows.all.search(query: query).filter { $0.processName != SafariApplication.processName }
}


func searchSafariTabs(query: String) -> [AlfredItem] {
    guard let s = SafariApplication.create() else {
        return []
    }
    return s.windows.flatMap { return $0.tabs }.search(query: query)
}

func search(query: String) {
    let alfredItems = [
        searchWindowsExceptSafari(query: query),
        searchSafariTabs(query: query)
    ].flatMap { $0 }

    print(AlfredDocument(withItems: alfredItems).xml.xmlString)
}


for command in CommandLine.commands() {
    switch command {
    case let searchCommand as SearchCommand:
        search(query: searchCommand.query)
        exit(0)
    default:
        print("Unknown command!")
        print("Commands:")
        print("--search=<query> to search for active windows/Safari tabs.")
        exit(1)
    }
}

