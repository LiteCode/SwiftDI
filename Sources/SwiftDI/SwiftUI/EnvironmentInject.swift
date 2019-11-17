//
//  EnvironmentInject.swift
//  SwiftDI
//
//  Created by Vladislav Prusakov on 17.11.2019.
//

#if canImport(SwiftUI)
import SwiftUI
import Combine

/// A property wrapper that inject object from environment container
/// Read only object
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct EnvironmentInject<Value: AnyObject>: DynamicProperty {
    
    public let wrappedValue: Value
    
    public init() {
        let bundle = Bundle(for: Value.self)
        let resolvedValue = Environment(\.container).wrappedValue.resolve(bundle: bundle) as Value
        self.wrappedValue = resolvedValue
    }
}

#endif
