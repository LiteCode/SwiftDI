//
//  DIComponentContext.swift
//  SwiftDI
//
//  Created by v.a.prusakov on 01/07/2019.
//

import Foundation

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
