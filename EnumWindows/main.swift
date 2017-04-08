import Foundation


func searchBrowserTabs(processName: String, query: String) -> [AlfredItem] {
    return BrowserApplication.connect(processName: processName)?.windows
            .flatMap { return $0.tabs }
            .search(query: query) ?? []
}


func searchBrowserTabsIfNeeded(processName: String, windows: [WindowInfoDict], query: String) -> ([AlfredItem], [WindowInfoDict]) {
    
    let activeWindowsExceptBrowser = windows.filter { ($0.processName != processName) }
    
    let browserTabs = searchBrowserTabs(processName: processName, query: query)
    
    return (browserTabs, activeWindowsExceptBrowser)
}

func search(query: String, onlyTabs: Bool) {
    let allActiveWindows = Windows.all
    
    let (safariTabs, filteredWindows) = searchBrowserTabsIfNeeded(processName: "Safari",
                                                                  windows: allActiveWindows,
                                                                  query: query)
    
    let (chromeTabs, filteredWindows2) = searchBrowserTabsIfNeeded(processName: "Google Chrome",
                                                                   windows: filteredWindows,
                                                                   query: query)
    
    let alfredItems : [AlfredItem] = [
        onlyTabs ? [] : filteredWindows2.search(query: query),
        safariTabs,
        chromeTabs,
    ].flatMap { $0 }

    print(AlfredDocument(withItems: alfredItems).xml.xmlString)
}


for command in CommandLine.commands() {
    switch command {
    case let searchCommand as SearchCommand:
        search(query: searchCommand.query, onlyTabs: false)
        exit(0)
    case let searchCommand as OnlyTabsCommand:
        search(query: searchCommand.query, onlyTabs: true)
        exit(0)
    default:
        print("Unknown command!")
        print("Commands:")
        print("--search=<query> to search for active windows/Safari tabs.")
        exit(1)
    }
}

