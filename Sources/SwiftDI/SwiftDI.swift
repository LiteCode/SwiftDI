import Foundation

public enum SwiftDI {
    internal private(set) static var sharedContainer: DIContainerConvertible = DIContainer()
    
    public static func useContainer(_ container: DIContainerConvertible) {
        self.sharedContainer = container
        container.didConnectToSwiftDI()
    }
}

class LazyIniter {
    
    var initBlock: () -> Any
    
    init(initBlock: @escaping () -> Any) {
        self.initBlock = initBlock
    }
    
    func resolve<T>() -> T {
        return self.initBlock() as! T
    }
    
}

public protocol DIPart {
    static func load(container: DIContainer)
}

class DIComponentManager {
    
    let locker = NSLock()
    
    lazy var registerContainers: [ObjectIdentifier: DIObject] = [:]
    
    func insert<T>(_ object: DIObject, forType type: T.Type) {
        locker.sync { self.registerContainers[ObjectIdentifier(type)] = object }
    }
    
    subscript<T>(_ type: T.Type) -> DIObject? {
        return locker.sync { self.registerContainers[ObjectIdentifier(type)] }
    }
    
    var objects: [DIObject] {
        return locker.sync { self.registerContainers.values.compactMap{ $0 } }
    }
    
}

public enum DILifeCycle {
    case singletone
    case prototype
}

class DIObject {
    
    let lazy: LazyIniter
    let type: Any.Type
    
    var bundle: Bundle? {
        if let anyClass = type as? AnyClass {
            return Bundle(for: anyClass)
        }
        
        return nil
    }
    
    init(lazy: LazyIniter, type: Any.Type) {
        self.lazy = lazy
        self.type = type
    }
    
    var lifeCycle: DILifeCycle = .prototype
}

public class DIComponentContext<T> {
    
    private var manager: DIComponentManager
    private var object: DIObject
    
    init(container: DIContainer, object: DIObject) {
        self.manager = container.componentManager
        self.object = object
        self.manager.insert(object, forType: T.self)
    }
    
    @discardableResult
    public func lifeCycle(_ lifeCycle: DILifeCycle) -> DIComponentContext<T> {
        self.object.lifeCycle = lifeCycle
        return self
    }
    
    @discardableResult
    public func `as`<U>(_ type: U.Type) -> DIComponentContext<T> {
        self.manager.insert(self.object, forType: type)
        return self
    }
}

public class DIContainer: DIContainerConvertible, CustomStringConvertible {
    
    public var description: String {
        return componentManager.registerContainers.description
    }
    
    lazy var resolver: DIResolver = DIResolver(container: self)
    
    lazy var componentManager: DIComponentManager = DIComponentManager()
    
    public func appendPart(_ part: DIPart.Type) {
        part.load(container: self)
    }
    
    @discardableResult
    public func register<T>(_ initialize: @escaping () -> T) -> DIComponentContext<T> {
        let initer = LazyIniter(initBlock: initialize)
        return DIComponentContext(container: self, object: DIObject(lazy: initer, type: T.self))
    }
    
    public func resolve<T>(bundle: Bundle? = nil) -> T {
        return resolver.resolve(bundle: bundle)
        
    }
    
    public func didConnectToSwiftDI() {
        self.resolveSingletones()
    }
    
    // MARK: - Private
    
    func resolveSingletones() {
        let objects = componentManager.objects.filter { $0.lifeCycle == .singletone }
        for object in objects {
            resolver.addSingletone(object)
        }
    }
    
}

class DIResolver {
    
    lazy var storage: [ObjectIdentifier: Any] = [:]
    private unowned let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func addSingletone(_ object: DIObject) {
        let resolvedObject = object.lazy.resolve() as Any
        storage[ObjectIdentifier(object.type)] = resolvedObject
    }
    
    func resolve<T>(bundle: Bundle? = nil) -> T {
        let object = self.findObject(for: T.self, bundle: bundle)
        
        switch object.lifeCycle {
        case .singletone:
            return storage[ObjectIdentifier(object.type)] as! T
        case .prototype:
            return object.lazy.resolve()
        }
    }
    
    func findObject<T>(for type: T.Type, bundle: Bundle?) -> DIObject {
        guard let object = self.container.componentManager[type] else {
            fatalError("Can't found object for type \(type)")
        }
        if let bundle = bundle {
            if object.bundle != bundle {
                fatalError("Bundles isn't equals")
            }
        }
        
        return object
    }
}
