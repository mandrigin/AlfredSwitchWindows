import Foundation


func searchWindows(query: String, exceptSafari: Bool) -> [AlfredItem] {
    return Windows.all.search(query: query).filter { !exceptSafari || ($0.processName != SafariApplication.processName) }
}


func searchSafariTabs(query: String) -> [AlfredItem] {
    return SafariApplication.create()?.windows
            .flatMap { return $0.tabs }
            .search(query: query) ?? []
}

func search(query: String) {
    let safariTabs = searchSafariTabs(query: query)
    let alfredItems = [
        searchWindows(query: query, exceptSafari: safariTabs.count > 0),
        safariTabs,
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

