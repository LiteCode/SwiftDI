import Foundation

public enum SwiftDI {
    
    /// Defaults settings for you DI
    public enum Defaults {
        /// Set life time for you instantces. By default is `DILifeCycle.objectGraph`
        public static var lifeCycle = DILifeCycle.objectGraph
    }
    
    internal private(set) static var sharedContainer: DIContainer = DIContainer()
    
    /// Use container for inject dependencies.
    public static func useContainer(_ container: DIContainer) {
        self.sharedContainer = container
        container.didConnectToSwiftDI()
    }
}

public enum DILifeCycle {
    /// Dependency is created one per container.
    case single
    
    /// Dependency instance is created each time.
    case prototype
    
    /// Dependency is created one per container, but destory when dependency object will deinit.
    case weakSingle
    
    /// Dependency instance is created one per object graph.
    case objectGraph
}

extension DILifeCycle: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .single: return "single"
        case .prototype: return "protorype"
        case .weakSingle: return "weakSingle"
        case .objectGraph: return "objectGraph"
        }
    }
}
