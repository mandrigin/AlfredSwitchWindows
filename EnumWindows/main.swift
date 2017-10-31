import Foundation

/// Removes browser window from the list of windows and adds tabs to the results array
func searchBrowserTabsIfNeeded(processName: String,
                               windows: [WindowInfoDict],
                               query: String,
                               results: inout [[AlfredItem]]) -> [WindowInfoDict] {
    
    let activeWindowsExceptBrowser = windows.filter { ($0.processName != processName) }
    
    let browserTabs =
        BrowserApplication.connect(processName: processName)?.windows
            .flatMap { return $0.tabs }
            .search(query: query)
    
    results.append(browserTabs ?? [])
    
    return activeWindowsExceptBrowser
}

func search(query: String, onlyTabs: Bool) {
    var results : [[AlfredItem]] = []
    
    var allActiveWindows : [WindowInfoDict] = Windows.all
    
    for browserName in ["Safari", "Safari Technology Preview", "Google Chrome", "Firefox", "FirefoxNightly"] {
        allActiveWindows = searchBrowserTabsIfNeeded(processName: browserName,
                                                     windows: allActiveWindows,
                                                     query: query,
                                                     results: &results) // inout!
    }
    
    if !onlyTabs {
        results.append(allActiveWindows.search(query: query))
    }
    
    let alfredItems : [AlfredItem] = results.flatMap { $0 }

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

