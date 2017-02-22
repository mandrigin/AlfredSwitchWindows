import Foundation

extension WindowInfoDict : AlfredItem {
    var uid : String { return "1" };
    var autocomplete : String { return self.name };
    var title : String { return self.name };
    var subtitle : String { return "Process: \(self.processName) | App name: \(self.processName)" };
}

extension SafariTab : AlfredItem {
    var uid : String { return "1" };
    var autocomplete : String { return self.title };
    var subtitle : String { return "\(self.url)" };
    var processName : String { return SafariApplication.processName };
}
