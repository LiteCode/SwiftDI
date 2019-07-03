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
public struct InjectableObjectBinding<BindableObjectType>: DynamicViewProperty where BindableObjectType : BindableObject {
    
    var _bindingValue: ObjectBinding<BindableObjectType>
    
    public init() {
        let bundle = Bundle(for: BindableObjectType.self)
        let value: BindableObjectType = SwiftDI.sharedContainer.resolve(bundle: bundle)
        _bindingValue = ObjectBinding<BindableObjectType>(initialValue: value)
        self.wrapperValue = _bindingValue.wrapperValue
    }
    
    public var wrappedValue: BindableObjectType {
        get { return _bindingValue.value }
    }
    
    public private(set) var wrapperValue: ObjectBinding<BindableObjectType>.Wrapper
}
#endif

