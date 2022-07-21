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
    
    for browserName in ["Safari", "Safari Technology Preview",
                        "Google Chrome", "Google Chrome Canary",
                        "Opera", "Opera Beta", "Opera Developer",
                        "Brave Browser", "iTerm"] {
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

func handleCatalinaScreenRecordingPermission() {
    guard let firstWindow = Windows.any else {
        return
    }

    guard !firstWindow.hasName else {
        return
    }

    let windowImage = CGWindowListCreateImage(.null, .optionIncludingWindow,
                                              firstWindow.number,
                                              [.boundsIgnoreFraming, .bestResolution])
    if windowImage == nil {
        debugPrint("Before using this app, you need to give permission in System Preferences > Security & Privacy > Privacy > Screen Recording.\nPlease authorize and re-launch.")
        exit(1)
    }
}

handleCatalinaScreenRecordingPermission()

/*
 a naive perf test, decided to keep it here for convenience

let start = DispatchTime.now() // <<<<<<<<<< Start time

for _ in 0...100 {
    search(query: "pull", onlyTabs: false)
}
let end = DispatchTime.now()   // <<<<<<<<<<   end time
let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

print("TIME SPENT: \(timeInterval)")
*/

if(CommandLine.commands().isEmpty) {
    print("Unknown command!")
    print("Commands:")
    print("--search=<query> to search for active windows/Safari tabs.")
    print("--search-tabs=<query> to search for active browser tabs.")
    exit(1)
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
        print("--search-tabs=<query> to search for active browser tabs.")
        exit(1)
    }
    
}
