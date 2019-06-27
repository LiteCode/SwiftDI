//
//  File.swift
//  
//
//  Created by v.a.prusakov on 27/06/2019.
//

import Foundation

/// Read only property wrapper injector.
@propertyWrapper
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

/// Working with SwiftUI
/// Automaticly update the view when `BindableObjectType` changed.
@propertyDelegate
public struct BindObjectInjectable<BindableObjectType>: DynamicViewProperty where BindableObjectType : BindableObject {
    
    var _value: BindableObjectType
    var binding: ObjectBinding<BindableObjectType>
    
    public init() {
        let bundle = (T.self as? AnyClass).flatMap { Bundle(for: $0) }
        _value = SwiftDI.sharedContainer.resolve(bundle: bundle)
        self.binding = ObjectBinding<BindableObjectType>(initialValue: value)
        self.delegateValue = binding.delegateValue
        self.storageValue = binding.storageValue
    }
    
    public var value: BindableObjectType {
        get { return _value }
    }
    
    public private(set) var delegateValue: ObjectBinding<BindableObjectType>.Wrapper
    
    public private(set) var storageValue: ObjectBinding<BindableObjectType>.Wrapper
}
