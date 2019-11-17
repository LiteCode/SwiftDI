//
//  DIComponentManager.swift
//  SwiftDI
//
//  Created by v.a.prusakov on 01/07/2019.
//

import Foundation

class DIComponentManager {
    
    let locker = NSRecursiveLock()
    
    lazy var registerContainers: [ObjectIdentifier: DIObject] = [:]
    
    func insert<T>(_ object: DIObject, forType type: T.Type) {
        locker.sync { self.registerContainers[ObjectIdentifier(type)] = object }
    }
    
    subscript(_ type: Any.Type) -> DIObject? {
        return locker.sync { self.registerContainers[ObjectIdentifier(type)] }
    }
    
    var objects: [DIObject] {
        return locker.sync { self.registerContainers.values.compactMap{ $0 } }
    }
    
}
