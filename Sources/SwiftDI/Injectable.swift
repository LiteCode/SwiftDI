//
//  File.swift
//  
//
//  Created by v.a.prusakov on 27/06/2019.
//

import Foundation

/// Read only property wrapper.
@propertyWrapper
public struct Injectable<T> {
    
    var bundle: Bundle?
    
    public init() {
        self.bundle = (T.self as? AnyClass).flatMap { Bundle(for: $0) }
    }
    
    public var value: T {
        get {
            return SwiftDI.sharedContainer.resolve(bundle: bundle)
        }
    }
}
