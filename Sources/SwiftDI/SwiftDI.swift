
public class SwiftDI {
    public static var sharedContainer: DIContainer = DIContainer()
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

class DIComponent {
    lazy var registerContainers: [String: Any] = [:]
    
    func insert(_ object: Any, forKey key: String) {
        self.registerContainers[key] = object
    }
    
    func insert<T>(_ object: Any, forType type: T.Type) {
        let key = String(describing: type)
        self.registerContainers[key] = object
    }
    
    subscript(_ key: String) -> Any? {
        return registerContainers[key]
    }
    
}

public class DIComponentContext<T> {
    
    private var components: DIComponent
    private var lazyObject: LazyIniter
    
    init(container: DIContainer, lazyObject: LazyIniter) {
        self.components = container.components
        self.lazyObject = lazyObject
        self.components.insert(lazyObject, forType: T.self)
    }
    
    @discardableResult
    public func `as`<U>(_ type: U.Type) -> DIComponentContext<T> {
        self.components.insert(self.lazyObject, forType: type)
        return self
    }
}

public class DIContainer: CustomStringConvertible {
    
    public var description: String {
        return components.registerContainers.description
    }
    
    lazy var components: DIComponent = DIComponent()
    
    public func loadPart(_ part: DIPart.Type) {
        part.load(container: self)
    }
    
    @discardableResult
    public func register<T>(_ initialize: @escaping () -> T) -> DIComponentContext<T> {
        return DIComponentContext(container: self, lazyObject: LazyIniter(initBlock: initialize))
    }
    
    public func resolve<T>() -> T {
        let key = String(describing: T.self)
        let container = components[key]
        if let lazyObject = container as? LazyIniter {
            return lazyObject.resolve()
        } else {
            return container as! T
        }
        
    }
    
}

@propertyDelegate
public struct Injectable<T> {
    
    public init() { }
    
    private var _value: T?
    
    public var value: T {
        get {
            return _value ?? SwiftDI.sharedContainer.resolve()
        }
        
        set {
            _value = newValue
        }
    }
}
