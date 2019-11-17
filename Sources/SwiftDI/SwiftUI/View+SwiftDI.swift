//
//  View+SwiftDI.swift
//  SwiftDI
//
//  Created by Vladislav Prusakov on 17.11.2019.
//

#if canImport(SwiftUI)
import SwiftUI

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

struct DIContainerEnvironmentKey: EnvironmentKey {
    static var defaultValue: DIContainer = SwiftDI.sharedContainer
}

extension EnvironmentValues {
    var container: DIContainer {
        get { self[DIContainerEnvironmentKey.self] }
        set { self[DIContainerEnvironmentKey.self] = newValue }
    }
}

#endif
