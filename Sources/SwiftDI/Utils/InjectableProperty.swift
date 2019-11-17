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

extension Inject: InjectableProperty {
    var type: Any.Type {
        return Value.self
    }
}

#if canImport(SwiftUI)

@available(iOS 13.0, *)
extension EnvironmentInject: InjectableProperty {
    var type: Any.Type {
        return Value.self
    }
}

@available(iOS 13.0, *)
extension EnvironmentObservedInject: InjectableProperty {
    var type: Any.Type {
        return Value.self
    }
}

#endif
