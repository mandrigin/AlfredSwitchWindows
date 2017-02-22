import Foundation

extension WindowInfoDict : AlfredItem {
    var uid : String { return "1" };
    var arg : String { return "\(self.processName)|||||\(self.tabIndex)|||||\(self.windowTitle)" };
    var autocomplete : String { return self.name };
    var title : String { return self.name };
    var icon : String { return "switch.png" };
    var subtitle : String { return "Process: \(self.processName) | App name: \(self.processName)" };
}

extension SafariTab : AlfredItem {
    var uid : String { return "1" };
    var arg : String { return "\(SafariApplication.processName)|||||\(self.tabIndex)|||||\(self.windowTitle)" };
    var autocomplete : String { return self.title };
    var icon : String { return "switch.png" };
    var subtitle : String { return "\(self.url)" };
}
