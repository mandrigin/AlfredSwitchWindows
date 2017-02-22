import Foundation

protocol AlfredItem {
    var uid : String { get };
    var arg : String { get };
    var autocomplete : String { get };
    var title : String { get };
    var icon : String { get };
    var subtitle : String { get };
    var processName : String { get };
    var tabIndex : Int { get };
}

extension AlfredItem {

    var arg : String { return "\(self.processName)|||||\(self.tabIndex)|||||\(self.title)" };
    var icon : String { return AppIcon(appName: self.processName).path };

    var xmlNode : XMLNode {
        /*
         <item uid="1"
         arg="Brand spanking new process - Google Docs"
         autocomplete="Brand spanking new process - Google Docs">
         <icon>/Applications/Safari.app/Contents/Resources/compass.icns</icon>
         <title>Brand spanking new process - Google Docs</title>
         <subtitle> Process: Safari | App name: Safari.app</subtitle>
         </item>
         */
        let element = XMLElement(name: "item")
        
        element.addAttribute(XMLNode.attribute(withName: "uid", stringValue: self.uid) as! XMLNode)
        element.addAttribute(XMLNode.attribute(withName: "arg", stringValue: self.arg) as! XMLNode)
        element.addAttribute(XMLNode.attribute(withName: "autocomplete", stringValue: self.autocomplete) as! XMLNode)
        
        let titleElement = XMLElement(name: "title")
        titleElement.addChild(XMLNode.text(withStringValue: self.title) as! XMLNode)
        element.addChild(titleElement)
        
        let iconElement = XMLElement(name: "icon")
        iconElement.addChild(XMLNode.text(withStringValue: self.icon) as! XMLNode)
        element.addChild(iconElement)
        
        let subtitleElement = XMLElement(name: "subtitle")
        subtitleElement.addChild(XMLNode.text(withStringValue: self.subtitle) as! XMLNode)
        element.addChild(subtitleElement)
        
        return element
    }
}

struct AlfredDocument {
    let items : [AlfredItem]
    
    init(withItems: [AlfredItem]) {
        self.items = withItems;
    }
    
    var xml : XMLDocument {
        let root = XMLElement(name: "items")
        
        for item in self.items {
            root.addChild(item.xmlNode)
        }
        return XMLDocument(rootElement: root)
    }
}
