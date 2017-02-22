//
//  AppIconGrabber.swift
//  EnumWindows
//
//  Created by Igor Mandrigin on 2017-02-22.
//  Copyright © 2017 Igor Mandrigin. All rights reserved.
//

import Foundation
import AppKit

struct AppIcon {
    
    let appName : String
    
    init(appName: String) {
        self.appName = appName
    }
    
    var path : String {
        guard let path = self.pathInternal else {
            return "switch.png"
        }
        
        return path
    }
    
    private var pathInternal : String? {
        let workspace = NSWorkspace.shared()
        
        guard let appPath = workspace.fullPath(forApplication: self.appName) else {
            return nil
        }
        
        let bundle = Bundle(path: appPath)
        
        guard let iconFileNameObj = bundle?.infoDictionary?["CFBundleIconFile"] else {
            return nil
        }
        
        guard let iconFileName = iconFileNameObj as? String else {
            return nil
        }
        
        let url = URL(fileURLWithPath: appPath)
                .appendingPathComponent("Contents")
                .appendingPathComponent("Resources")
                .appendingPathComponent("\(iconFileName).icns")
        
        return url.path
    }
}
