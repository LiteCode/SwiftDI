//
//  BindObjectInjectable.swift
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
public struct BindObjectInjectable<BindableObjectType>: DynamicViewProperty where BindableObjectType : BindableObject {
    
    var _value: BindableObjectType
    var binding: ObjectBinding<BindableObjectType>
    
    public init() {
        let bundle = Bundle(for: BindableObjectType.self)
        _value = SwiftDI.sharedContainer.resolve(bundle: bundle)
        self.binding = ObjectBinding<BindableObjectType>(initialValue: _value)
        self.delegateValue = binding.delegateValue
        self.storageValue = binding.storageValue
    }
    
    public var value: BindableObjectType {
        get { return _value }
    }
    
    public private(set) var delegateValue: ObjectBinding<BindableObjectType>.Wrapper
    
    public private(set) var storageValue: ObjectBinding<BindableObjectType>.Wrapper
}
#endif

