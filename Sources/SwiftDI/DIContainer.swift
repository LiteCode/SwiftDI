//
//  DIContainer.swift
//  
//
//  Created by v.a.prusakov on 01/07/2019.
//

import Foundation

public class DIContainer: DIContainerConvertible, CustomStringConvertible {
    
    public var description: String {
        return componentManager.registerContainers.description
    }
    
    var componentManager: DIComponentManager
    lazy var resolver: DIResolver = DIResolver(container: self)
    
    public init() {
        componentManager = DIComponentManager()
    }
    
    public func appendPart(_ part: DIPart.Type) {
        part.load(container: self)
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
    
}
