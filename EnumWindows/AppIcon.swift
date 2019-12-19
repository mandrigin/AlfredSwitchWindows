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
        return self.pathInternal ?? "switch.png"
    }
    
    private var pathInternal : String? {
        let appPath = self.appName | { NSWorkspace.shared.fullPath(forApplication: $0) }
        
        guard var iconFileName = appPath | { Bundle(path: $0) } | { $0.infoDictionary?["CFBundleIconFile"] } | { $0 as? String } else {
            return nil
        }
        
        if !iconFileName.hasSuffix(".icns") {
            iconFileName.append(".icns")
        }
        
        let url = appPath | { URL(fileURLWithPath: $0) } | { $0.appendingPathComponent("Contents/Resources/\(iconFileName)") }
        
        return url?.path ?? nil
    }
}

/**
 * Just having fun with the pipelining
 */
precedencegroup PipelinePrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}
infix operator | : PipelinePrecedence

func | <A, B> (lhs : A?, rhs : (A) -> B?) -> B? {
    guard let l = lhs else {
        return nil
    }
    
    return rhs(l)
}
