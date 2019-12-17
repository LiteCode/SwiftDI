//
//  Injectable.swift
//  
//
//  Created by v.a.prusakov on 27/06/2019.
//

import Foundation
import Combine

/// Read only property wrapper injector.

@propertyWrapper
public struct Inject<Value> {
    
    // Injectable using lazy initialization, because instead cycle dependencies will crash in init.
    typealias LazyInject = () -> Value
    
    var _value: Value?
    var lazy: LazyInject?
    
    public init() {
        let bundle = (Value.self as? AnyClass).flatMap { Bundle(for: $0) }
        let lazy: LazyInject = { SwiftDI.sharedContainer.resolve(bundle: bundle) }
        self.lazy = lazy
    }
    
    public var wrappedValue: Value {
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
