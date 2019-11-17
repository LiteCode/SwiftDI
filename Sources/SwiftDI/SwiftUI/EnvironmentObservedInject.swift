//
//  EnvironmentObservedInject.swift
//  SwiftDI
//
//  Created by v.a.prusakov on 27/06/2019.
//

#if canImport(SwiftUI)
import SwiftUI
import Combine

/// A dynamic view property that subscribes to a `ObservableObject` automatically invalidating the view
/// when it changes.
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct EnvironmentObservedInject<Value: ObservableObject>: DynamicProperty {
    
    @ObservedObject private var _wrappedValue: Value
    public var wrappedValue: Value {
        _wrappedValue
    }
    
    public init() {
        let bundle = Bundle(for: Value.self)
        let resolvedValue = Environment(\.container).wrappedValue.resolve(bundle: bundle) as Value
        self.__wrappedValue = ObservedObject<Value>(initialValue: resolvedValue)
    }
    
    /// The binding value, as "unwrapped" by accessing `$foo` on a `@Binding` property.
    public var projectedValue: ObservedObject<Value>.Wrapper {
        return __wrappedValue.projectedValue
    }
}

#endif

