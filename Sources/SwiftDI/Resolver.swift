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
        if let object = makeObject(for: T.self, bundle: bundle, usingObject: nil) {
            return object as! T
        } else {
            fatalError("Couldn't found object for type \(T.self)")
        }
    }
    
    func makeObject(for type: Any.Type, bundle: Bundle?, usingObject: DIObject?) -> Any? {
        let object = usingObject ?? findObject(for: type, bundle: bundle)
        let key = ObjectIdentifier(object.type)
        
        switch object.lifeCycle {
        case .single:
            return storage[key]
        case .prototype:
            return object.lazy.resolve()
        case .weakSingle:
            if let weakReference = storage[key] as? Weak<AnyObject> {
                return weakReference.value
            }
            
            let resolvedObject = object.lazy.resolve() as AnyObject
            let weakObject = Weak(value: resolvedObject)
            storage[key] = weakObject
            return resolvedObject
        case .objectGraph:
            
            defer { objectGraphStackDepth -= 1 }
            
            if let object = objectGraphStorage[key] {
                if objectGraphStackDepth == 0 {
                    objectGraphStorage.removeAll()
                }
                return object
            }
            
            objectGraphStackDepth += 1
            let value = object.lazy.resolve() as Any
            objectGraphStorage[key] = value
            
            let mirror = Mirror(reflecting: value)
            
            for child in mirror.children {
                if let injectable = child.value as? InjectableProperty {
                    let subject = findObject(for: injectable.type, bundle: injectable.bundle)
                    if subject.lifeCycle != .single && subject.lifeCycle != .weakSingle {
                        objectGraphStackDepth += 1
                        objectGraphStorage[ObjectIdentifier(subject.type)] = self.makeObject(for: subject.type, bundle: subject.bundle, usingObject: subject)
                    }
                }
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
