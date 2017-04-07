import Foundation


func searchBrowserTabs(processName: String, query: String) -> [AlfredItem] {
    return BrowserApplication.create(processName: processName)?.windows
            .flatMap { return $0.tabs }
            .search(query: query) ?? []
}


func searchBrowserTabsIfNeeded(processName: String, windows: [WindowInfoDict], query: String) -> ([AlfredItem], [WindowInfoDict]) {
    
    let activeWindowsExceptBrowser = windows.filter { ($0.processName != processName) }
    let browserIsRunning = activeWindowsExceptBrowser.count < windows.count
    
    // `searchSafariTabs` will open Safari it it is not running. We want to avoid this behaviour,
    // so if no Safari process is there — don't search for tabs.
    let browserTabs = browserIsRunning ? searchBrowserTabs(processName: processName, query: query) : []
    
    return (browserTabs, activeWindowsExceptBrowser)
}

func search(query: String) {
    let allActiveWindows = Windows.all
    
    let (safariTabs, filteredWindows) = searchBrowserTabsIfNeeded(processName: "Safari",
                                                                  windows: allActiveWindows,
                                                                  query: query)
    
    let (chromeTabs, filteredWindows2) = searchBrowserTabsIfNeeded(processName: "Google Chrome",
                                                                   windows: filteredWindows,
                                                                   query: query)
    
    let alfredItems : [AlfredItem] = [
        filteredWindows2.search(query: query),
        safariTabs,
        chromeTabs,
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

