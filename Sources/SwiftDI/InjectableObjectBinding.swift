//
//  InjectableObjectBinding.swift
//  
//
//  Created by v.a.prusakov on 27/06/2019.
//

#if canImport(SwiftUI)
import SwiftUI

/// Working with SwiftUI
/// Automaticly update the view when `BindableObjectType` changed.
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct InjectableObjectBinding<BindableObjectType>: DynamicProperty where BindableObjectType : ObservableObject {
    
    var _bindingValue: Binding<BindableObjectType>
    
    public init() {
        let bundle = Bundle(for: BindableObjectType.self)
        let value: BindableObjectType = SwiftDI.sharedContainer.resolve(bundle: bundle)
        _bindingValue = Binding<BindableObjectType>.constant(value)
        self.projectedValue = _bindingValue.projectedValue
    }
    
    public var wrappedValue: BindableObjectType {
        get { return _bindingValue.wrappedValue }
    }
    
    public private(set) var projectedValue: Binding<BindableObjectType>
}

///// A modifier that needs to be resolved in an environment before it can be used.
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//public protocol DIEnvironmentalModifier : ViewModifier where Self.Body == Never {
//
//    /// The type of modifier to use after being resolved.
//    associatedtype ResolvedModifier : ViewModifier
//
//    /// Resolve to a concrete modifier in the given `environment`.
//    func resolve(in environment: EnvironmentValues) -> Self.ResolvedModifier
//}
//
//struct DIEnvironmentModifier: ViewModifier {
//
//    typealias Body = Never
//
//    func body(content: _ViewModifier_Content<DIEnvironmentModifier>) -> Never {
//        content.envi
//    }
//}

#endif

