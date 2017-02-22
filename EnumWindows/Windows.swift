import Foundation

class WindowInfoDict : Searchable {
    private let windowInfoDict : Dictionary<NSObject, AnyObject>;
    
    init(rawDict : UnsafeRawPointer) {
        windowInfoDict = unsafeBitCast(rawDict, to: CFDictionary.self) as Dictionary
    }
    
    var name : String {
        return self.dictItem(key: "kCGWindowName", defaultValue: "")
    }
    
    var windowTitle: String {
        return self.name
    }
    
    var processName : String {
        return self.dictItem(key: "kCGWindowOwnerName", defaultValue: "")
    }
    
    var appName : String {
        return self.dictItem(key: "kCGWindowOwnerName", defaultValue: "")
    }
    
    var pid : Int {
        return self.dictItem(key: "kCGWindowOwnerPID", defaultValue: -1)
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
    
    static func == (lhs: WindowInfoDict, rhs: WindowInfoDict) -> Bool {
        return lhs.processName == rhs.processName && lhs.name == rhs.name
    }
    
    var hashValue: Int {
        return "\(self.processName)-\(self.name)".hashValue
    }
    
    var searchStrings: [String] {
        return [self.processName, self.name]
    }
}

struct Windows {
    static var all : [WindowInfoDict] {
        get {
            guard let wl = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) else {
                return []
            }
            
            return (0..<CFArrayGetCount(wl)).flatMap { (i : Int) -> [WindowInfoDict] in
                guard let windowInfoRef = CFArrayGetValueAtIndex(wl, i) else {
                    return []
                }
                
                let wi = WindowInfoDict(rawDict: windowInfoRef)
                
                guard wi.name.characters.count > 0 else {
                    return []
                }
                
                return [wi]
            }
        }
    }
}
