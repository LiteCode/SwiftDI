//
//  Resolver.swift
//  
//
//  Created by v.a.prusakov on 01/07/2019.
//

import Foundation

class DIResolver {
    
    lazy var storage: [ObjectIdentifier: Any] = [:]
    lazy var objectGraphStorage: [ObjectIdentifier: Any] = [:]
    private unowned let container: DIContainer
    var objectGraphStackDepth: Int = 0
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func addSingletone(_ object: DIObject) {
        let resolvedObject = object.lazy.resolve() as Any
        storage[ObjectIdentifier(object.type)] = resolvedObject
    }
    
    func resolve<T>(bundle: Bundle? = nil) -> T {
        let object = findObject(for: T.self, bundle: bundle)
        let key = ObjectIdentifier(object.type)
        
        switch object.lifeCycle {
        case .single:
            return storage[key] as! T
        case .prototype:
            return object.lazy.resolve()
        case .weakSingle:
            if let weakReference = storage[key] as? Weak<AnyObject> {
                return weakReference.value as! T
            }
            
            let resolvedObject = object.lazy.resolve() as AnyObject
            let weakObject = Weak(value: resolvedObject)
            storage[key] = weakObject
            return resolvedObject as! T
        case .objectGraph:
            if let object = objectGraphStorage[key] as? T {
                return object
            }
            
            objectGraphStackDepth += 1
            let value: T = object.lazy.resolve()
            objectGraphStackDepth -= 1
            
            objectGraphStorage[key] = value
            
            let mirror = Mirror(reflecting: value)
            
            for child in mirror.children {
                if let injectable = child.value as? InjectableProperty {
                    let subject = findObject(for: injectable.type, bundle: injectable.bundle)
                    if subject.lifeCycle != .single && subject.lifeCycle != .weakSingle {
                        objectGraphStackDepth += 1
                        objectGraphStorage[ObjectIdentifier(subject.type)] = subject.lazy.resolve()
                        objectGraphStackDepth -= 1
                    }
                }
            }
            
            if objectGraphStackDepth == 0 {
                objectGraphStorage.removeAll()
            }
            
            return value
        }
    }
    
    func findObject(for type: Any.Type, bundle: Bundle?) -> DIObject {
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
