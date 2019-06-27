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
    
    var _value: T
    
    public init() {
        let bundle = (T.self as? AnyClass).flatMap { Bundle(for: $0) }
        _value = SwiftDI.sharedContainer.resolve(bundle: bundle)
    }
    
    public var value: T {
        get { return _value }
    }
}
