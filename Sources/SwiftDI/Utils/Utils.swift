//
//  Utils.swift
//  
//
//  Created by v.a.prusakov on 01/07/2019.
//

import Foundation

class Weak<T: AnyObject>: CustomDebugStringConvertible {
    weak var value: T?
    
    init(value: T) {
        self.value = value
    }
    
    var debugDescription: String {
        let address = Unmanaged.passUnretained(self).toOpaque()
        let type = String(describing: T.self)
        return String(format: "<Weak<%@>>: %@, value: %@", type, address.debugDescription, value.debugDescription)
    }
}

class Lazy {
    
    var initBlock: () -> Any
    
    init(initBlock: @escaping () -> Any) {
        self.initBlock = initBlock
    }
    
    func resolve<T>() -> T {
        return self.initBlock() as! T
    }
    
}
