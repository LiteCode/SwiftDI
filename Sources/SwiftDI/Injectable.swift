//
//  Injectable.swift
//  
//
//  Created by v.a.prusakov on 27/06/2019.
//

import Foundation
import Combine

/// Read only property wrapper injector.
/// Injectable using lazy initialization, because instead cycle dependencies will crash in init.
@propertyDelegate
public struct Injectable<T> {
    
    typealias LazyInject = () -> T
    
    var _value: T?
    var lazy: LazyInject?
    
    public init() {
        let bundle = (T.self as? AnyClass).flatMap { Bundle(for: $0) }
        let lazy: LazyInject = { SwiftDI.sharedContainer.resolve(bundle: bundle) }
        self.lazy = lazy
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
