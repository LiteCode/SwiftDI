//
//  RegisterObject.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation

struct RegisterObject: Codable {
    var lifeTime: DILifeCycle
    var objectType: ObjectType
    var additionalType: [ObjectType]
    var location: FileLocation
}

public enum DILifeCycle: String, Codable {
    /// Dependency is created one per container.
    case single
    
    /// Dependency instance is created each time.
    case prototype
    
    /// Dependency is created one per container, but destory when dependency object will deinit.
    case weakSingle
    
    /// Dependency instance is created one per object graph.
    case objectGraph
    
    case `default`
}
