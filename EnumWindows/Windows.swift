import Foundation

class WindowInfo : Hashable {
    private let windowInfoDict : Dictionary<NSObject, AnyObject>;
    
    init(rawDict : UnsafeRawPointer) {
        windowInfoDict = unsafeBitCast(rawDict, to: CFDictionary.self) as Dictionary
    }
    
    var name : String {
        get {
            return self.dictItem(key: "kCGWindowName", defaultValue: "")
        }
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
    
    func dictItem<T>(key : String, defaultValue : T) -> T {
        guard let value = windowInfoDict[key as NSObject] as? T else {
            return defaultValue
        }
        return value
    }
    
    var hashValue: Int {
        return "\(self.processName)-\(self.name)".hashValue
    }
    
    static func == (lhs: WindowInfo, rhs: WindowInfo) -> Bool {
        return lhs.processName == rhs.processName && lhs.name == rhs.name
    }
    
}

struct Windows {
    static var all : [WindowInfo] {
        get {
            guard let wl = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) else {
                return []
            }
            
            return (0..<CFArrayGetCount(wl)).flatMap { (i : Int) -> [WindowInfo] in
                guard let windowInfoRef = CFArrayGetValueAtIndex(wl, i) else {
                    return []
                }
                
                let wi = WindowInfo(rawDict: windowInfoRef)
                
                guard wi.name.characters.count > 0 else {
                    return []
                }
                
                return [wi]
            }
        }
    }
}

