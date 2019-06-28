//
//  Injectable.swift
//  
//
//  Created by v.a.prusakov on 27/06/2019.
//

import Foundation

/// Read only property wrapper injector.
@propertyDelegate
public struct Injectable<T> {
    
    typealias LazyInject = () -> T
    
    var _value: T?
    var lazy: LazyInject?
    
    public init(cycle: Bool = false) {
        let bundle = (T.self as? AnyClass).flatMap { Bundle(for: $0) }
        lazy = { SwiftDI.sharedContainer.resolve(bundle: bundle) }
        
        if !cycle {
            _value = lazy?()
        }
    }
    
    public init() {
        let bundle = (T.self as? AnyClass).flatMap { Bundle(for: $0) }
        _value = SwiftDI.sharedContainer.resolve(bundle: bundle)
    }
    
    public var value: T {
        mutating get {
            if let value = _value {
                return value
            } else if let lazy = self.lazy {
                self._value = lazy()
                return _value!
            } else {
                fatalError("Bad init")
            }
        }
    }
}
