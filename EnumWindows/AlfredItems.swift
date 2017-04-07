import Foundation

extension WindowInfoDict : AlfredItem {
    var uid : String { return "1" };
    var autocomplete : String { return self.name };
    var title : String { return self.name };
    var subtitle : String { return "Process: \(self.processName) | App name: \(self.processName)" };
    var arg: AlfredArg { return AlfredArg(arg1:self.processName, arg2:"\(self.tabIndex)", arg3:self.title) }
}

extension BrowserTab : AlfredItem {
    var uid : String { return "1" };
    var arg: AlfredArg { return AlfredArg(arg1:self.processName, arg2:"\(self.tabIndex)", arg3:self.windowTitle) }
    var autocomplete : String { return self.title };
    var subtitle : String { return "\(self.url)" };
}
