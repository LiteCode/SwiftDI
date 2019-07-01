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
@propertyDelegate
public struct InjectableObjectBinding<BindableObjectType>: DynamicViewProperty where BindableObjectType : BindableObject {
    
    var _bindingValue: ObjectBinding<BindableObjectType>
    
    public init() {
        let bundle = Bundle(for: BindableObjectType.self)
        let value: BindableObjectType = SwiftDI.sharedContainer.resolve(bundle: bundle)
        _bindingValue = ObjectBinding<BindableObjectType>(initialValue: value)
        self.delegateValue = _bindingValue.delegateValue
        self.storageValue = _bindingValue.storageValue
    }
    
    public var value: BindableObjectType {
        get { return _bindingValue.value }
    }
    
    public private(set) var delegateValue: ObjectBinding<BindableObjectType>.Wrapper
    
    public private(set) var storageValue: ObjectBinding<BindableObjectType>.Wrapper
}
#endif

