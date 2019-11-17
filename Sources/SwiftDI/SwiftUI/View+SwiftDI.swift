//
//  View+SwiftDI.swift
//  SwiftDI
//
//  Created by Vladislav Prusakov on 17.11.2019.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {
    
    /// Set dependency container to view
    func inject(container: DIContainer) -> some View {
        self.environment(\.container, container)
    }
    
    // Inject property into container
    func environmentInject<Value>(_ value: Value) -> some View {
        return self.transformEnvironment(\.container) { con in
            con.register({ value })
        }
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct DIContainerEnvironmentKey: EnvironmentKey {
    static var defaultValue: DIContainer = SwiftDI.sharedContainer
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    var container: DIContainer {
        get { self[DIContainerEnvironmentKey.self] }
        set { self[DIContainerEnvironmentKey.self] = newValue }
    }
}

#endif
