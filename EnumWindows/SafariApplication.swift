import Foundation
import ScriptingBridge

protocol SafariEntity {
    var rawItem : AnyObject { get }
}

protocol SafariNamedEntity : SafariEntity {
    var title : String { get }
}

extension SafariEntity {
    func performSelectorByName<T>(name : String, defaultValue : T) -> T {
        let sel = Selector(name)
        let selectorResult = self.rawItem.perform(sel)
        guard let retainedValue = selectorResult?.takeRetainedValue() else {
            return defaultValue
        }
        
        guard let result = retainedValue as? T else {
            return defaultValue
        }
        
        return result
    }
}

extension SafariNamedEntity {
    var title : String {
        return performSelectorByName(name: "name", defaultValue: "")
    }
}

class SafariTab : SafariNamedEntity, Searchable {
    private let tabRaw : AnyObject
    private let index : Int?
    
    let windowTitle : String
    
    init(raw: AnyObject, index: Int?, windowTitle: String) {
        tabRaw = raw
        self.index = index
        self.windowTitle = windowTitle
    }
    
    var rawItem: AnyObject {
        return self.tabRaw
    }
    
    var url : String {
        return performSelectorByName(name: "URL", defaultValue: "")
    }
    
    var tabIndex : Int {
        guard let i = index else {
            return 0
        }
        return i
    }
    
    var searchStrings : [String] {
        return [SafariApplication.processName, self.url, self.title]
    }
    
    /*
     (lldb) po raw.perform("URL").takeRetainedValue()
     https://encrypted.google.com/search?hl=en&q=objc%20mac%20list%20safari%20tabs#hl=en&q=swift+call+metho+by+name
     
     
     (lldb) po raw.perform("name").takeRetainedValue()
     scriptingbridge safaritab - Google Search
 */
}

class SafariWindow : SafariNamedEntity {
    private let windowRaw : AnyObject
    
    init(raw: AnyObject) {
        windowRaw = raw
    }
    
    var rawItem: AnyObject {
        return self.windowRaw
    }
    
    var tabs : [SafariTab] {
        let result = performSelectorByName(name: "tabs", defaultValue: [AnyObject]())
        
        return result.map {
            return SafariTab(raw: $0, index: $0.index, windowTitle: self.title)
        }
    }
}

class SafariApplication : SafariEntity {
    
    private let app : SBApplication
    
    static let processName = "Safari"
    
    static func create() -> SafariApplication? {
        guard let app = SBApplication(bundleIdentifier: "com.apple.Safari") else {
            return nil
        }
        
        return SafariApplication(app: app)
    }
    
    init(app: SBApplication) {
        self.app = app
    }
    
    var rawItem: AnyObject {
        return app
    }
    
    var windows : [SafariWindow] {
        let result = performSelectorByName(name: "windows", defaultValue: [AnyObject]())
        return result.map {
            return SafariWindow(raw: $0)
        }
    }
}
