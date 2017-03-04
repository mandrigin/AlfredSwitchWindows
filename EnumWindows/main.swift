import Foundation


func searchSafariTabs(query: String) -> [AlfredItem] {
    return SafariApplication.create()?.windows
            .flatMap { return $0.tabs }
            .search(query: query) ?? []
}

func search(query: String) {
    let allActiveWindows = Windows.all
    let activeWindowsExceptSafari = allActiveWindows.filter { ($0.processName != SafariApplication.processName) }
    
    let safariIsRunning = activeWindowsExceptSafari.count < allActiveWindows.count
    
    // `searchSafariTabs` will open Safari it it is not running. We want to avoid this behaviour,
    // so if no Safari process is there — don't search for tabs.
    let safariTabs = safariIsRunning ? searchSafariTabs(query: query) : []
    
    let alfredItems : [AlfredItem] = [
        activeWindowsExceptSafari.search(query: query),
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

