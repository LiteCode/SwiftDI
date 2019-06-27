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
    public var value: T {
        get {
            let bundle = (T.self as? AnyClass).flatMap { Bundle(for: $0) }
            return SwiftDI.sharedContainer.resolve(bundle: bundle)
        }
    }
}
