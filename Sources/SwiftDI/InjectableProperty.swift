//
//  InjectableProperty.swift
//  
//
//  Created by v.a.prusakov on 01/07/2019.
//

import Foundation

protocol InjectableProperty {
    var type: Any.Type { get }
    var bundle: Bundle? { get }
}

extension InjectableProperty {
    var bundle: Bundle? {
        return (type as? AnyClass).flatMap { Bundle(for: $0) }
    }
}

extension Injectable: InjectableProperty {
    var type: Any.Type {
        return T.self
    }
}

@available(iOS 13.0, *)
extension InjectableObjectBinding: InjectableProperty {
    var type: Any.Type {
        return BindableObjectType.self
    }
}
