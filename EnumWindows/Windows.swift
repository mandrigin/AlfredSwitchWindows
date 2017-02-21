import Foundation

class WindowInfo : Equatable {
    
    private let data : WindowInfoProtocol
    
    init(data: WindowInfoProtocol) {
        self.data = data
    }
    
    var name : String { return data.name }
    var processName : String { return data.processName }
    var pid : Int { return data.pid }
    var tabIndex : Int { return data.tabIndex }
    var windowTitle : String { return data.windowTitle }
    
    static func == (lhs: WindowInfo, rhs: WindowInfo) -> Bool {
        return lhs.processName == rhs.processName && lhs.name == rhs.name
    }
    
    var hashValue: Int {
        return "\(self.processName)-\(self.name)".hashValue
    }
    
    var searchStrings: [String] {
        return data.searchStrings
    }
}

protocol WindowInfoProtocol {
    var name : String { get }
    var processName : String { get }
    var pid : Int { get }
    var searchStrings : [String] { get }
    var tabIndex : Int { get }
    var windowTitle : String { get }
}

class WindowInfoDict : WindowInfoProtocol {
    private let windowInfoDict : Dictionary<NSObject, AnyObject>;
    
    init(rawDict : UnsafeRawPointer) {
        windowInfoDict = unsafeBitCast(rawDict, to: CFDictionary.self) as Dictionary
    }
    
    var name : String {
        get {
            return self.dictItem(key: "kCGWindowName", defaultValue: "")
        }
    }
    
    var windowTitle: String {
        return self.name
    }
    
    var processName : String {
        get {
            return self.dictItem(key: "kCGWindowOwnerName", defaultValue: "")
        }
    }
    
    var appName : String {
        get {
            return self.dictItem(key: "kCGWindowOwnerName", defaultValue: "")
        }
    }
    
    var pid : Int {
        get {
            return self.dictItem(key: "kCGWindowOwnerPID", defaultValue: -1)
        }
    }
    
    var searchStrings: [String] {
        return [self.processName, self.name]
    }
    
    var tabIndex: Int {
        return 0
    }
    
    
    func dictItem<T>(key : String, defaultValue : T) -> T {
        guard let value = windowInfoDict[key as NSObject] as? T else {
            return defaultValue
        }
        return value
    }

}

struct Windows {
    static var activeWindows : [WindowInfo] {
        get {
            guard let wl = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) else {
                return []
            }
            
            return (0..<CFArrayGetCount(wl)).flatMap { (i : Int) -> [WindowInfo] in
                guard let windowInfoRef = CFArrayGetValueAtIndex(wl, i) else {
                    return []
                }
                
                let wi = WindowInfoDict(rawDict: windowInfoRef)
                
                guard wi.name.characters.count > 0 else {
                    return []
                }
                
                return [WindowInfo(data:wi)]
            }
        }
    }
    static var all : [WindowInfo] {
        return activeWindows + safariTabs
    }
    
    static var safariTabs : [WindowInfo] {
        guard let safari =  SafariApplication.create() else {
            return []
        }
        
        return safari.windows.flatMap { return $0.tabs }.map { WindowInfo(data: $0) }
    }
}

extension SafariTab : WindowInfoProtocol {
    internal var pid: Int {
        return -1 // TODO: Implement
    }

    internal var processName: String {
        return "Safari"
    }

    internal var name: String {
        return self.title
    }

    var searchStrings: [String] {
        return [self.processName, self.title, self.url]
    }
}

