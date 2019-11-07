//
//  DIObject.swift
//  
//
//  Created by v.a.prusakov on 01/07/2019.
//

import Foundation

class DIObject {
    
    let lazy: Lazy
    let type: Any.Type
    
    var bundle: Bundle? {
        if let anyClass = type as? AnyClass {
            return Bundle(for: anyClass)
        }
        
        return nil
    }
    
    init(lazy: Lazy, type: Any.Type) {
        self.lazy = lazy
        self.type = type
    }
    
    var lifeCycle: DILifeCycle = SwiftDI.Defaults.lifeCycle
}
