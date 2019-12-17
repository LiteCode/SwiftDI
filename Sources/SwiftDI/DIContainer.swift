//
//  DIContainer.swift
//  SwiftDI
//
//  Created by v.a.prusakov on 01/07/2019.
//

import Foundation

public final class DIContainer: CustomStringConvertible {
    
    public var description: String {
        return componentManager.registerContainers.description
    }
    
    var componentManager: DIComponentManager
    lazy var resolver: DIResolver = DIResolver(container: self)
    
    public init() {
        componentManager = DIComponentManager()
    }
    
    public convenience init<Content: DIPart>(part: Content) {
        self.init()
        part.build(container: self)
    }
    
    public func appendPart<Content: DIPart>(_ part: Content.Type) {
        part.load(container: self)
    }
    
    public func appendPart<Content: DIPart>(_ part: Content) {
        part.build(container: self)
    }
    
    @discardableResult
    public func register<T>(_ initialize: @escaping () -> T) -> DIComponentContext<T> {
        let initer = Lazy(initBlock: initialize)
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
        let objects = componentManager.objects.filter { $0.lifeCycle == .single }
        for object in objects {
            resolver.addSingletone(object)
        }
    }
    
    @discardableResult
    func registerObject(_ object: DIObject) -> DIComponentContext<Any> {
        return DIComponentContext(container: self, object: object)
    }
    
    func mergeContainers(_ componentManager: DIComponentManager) {
        let newContainers = componentManager.registerContainers
        self.componentManager.registerContainers.merge(newContainers) { _, new in new }
    }
    
}
