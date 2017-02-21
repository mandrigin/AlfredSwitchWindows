import Foundation
import ScriptingBridge

class SafariTab {
    private let tabRaw : AnyObject
    private let index : Int?
    
    let windowTitle : String
    
    init(raw: AnyObject, index: Int?, windowTitle: String) {
        tabRaw = raw
        self.index = index
        self.windowTitle = windowTitle
    }
    
    var url : String {
        let urlSelector = Selector(("URL"))
        let urlRaw = tabRaw.perform(urlSelector)
        guard let urlString = urlRaw?.takeRetainedValue() else {
            return ""
        }
        
        guard let result = urlString as? String else {
            return ""
        }
        
        return result
    }
    
    var title : String {
        let urlSelector = Selector(("name"))
        let urlRaw = tabRaw.perform(urlSelector)
        guard let urlString = urlRaw?.takeRetainedValue() else {
            return ""
        }
        
        guard let result = urlString as? String else {
            return ""
        }
        
        return result
    }
    
    var tabIndex : Int {
        guard let i = index else {
            return 0
        }
        return i
    }
    
    /*
     (lldb) po raw.perform("URL").takeRetainedValue()
     https://encrypted.google.com/search?hl=en&q=objc%20mac%20list%20safari%20tabs#hl=en&q=swift+call+metho+by+name
     
     
     (lldb) po raw.perform("name").takeRetainedValue()
     scriptingbridge safaritab - Google Search
 */
}

class SafariWindow {
    private let windowRaw : AnyObject
    
    init(raw: AnyObject) {
        windowRaw = raw
    }
    
    var tabs : [SafariTab] {
        let tabsSel = Selector(("tabs"))
        
        let rawResult = windowRaw.perform(tabsSel)
        
        guard let result = rawResult?.takeRetainedValue() as? [AnyObject] else {
            return []
        }
        
        return result.map {
            return SafariTab(raw: $0, index: $0.index, windowTitle: self.title)
        }
    }
    
    var title : String {
        let urlSelector = Selector(("name"))
        let urlRaw = windowRaw.perform(urlSelector)
        guard let urlString = urlRaw?.takeRetainedValue() else {
            return ""
        }
        
        guard let result = urlString as? String else {
            return ""
        }
        
        return result
    }
}

class SafariApplication {
    
    private let app : SBApplication?
    
    static func create() -> SafariApplication? {
        guard let app = SBApplication(bundleIdentifier: "com.apple.Safari") else {
            return nil
        }
        
        return SafariApplication(app: app)
    }
    
    init(app: SBApplication) {
        self.app = app
    }
    
    var windows : [SafariWindow] {
        let windowsSel = Selector(("windows"))
        
        let rawResult = app?.perform(windowsSel)
        
        guard let result = rawResult?.takeRetainedValue() as? [AnyObject] else {
            return []
        }
        
        return result.map {
            return SafariWindow(raw: $0)
        }
    }
}
