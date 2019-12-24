//
//  DILintContext.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation

class DILintContext {
    var singletones: [RegisterObject] = []
    var graphObjects: [RegisterObject] = []
    var prototypies: [RegisterObject] = []
    var injected: [InjectedProperty] = []
    var parts: [DIPart] = []
    var unusedParts: [DIPart] = []
    
    func validate() throws {
        var errors: [Error] = []
        for inject in injected {
            let type = inject.injectedType
            if !(self.prototypies.contains(objectType: type) || self.singletones.contains(objectType: type) || self.graphObjects.contains(objectType: type)) {
                    errors.append(DIError.missRegistration(type: inject.injectedType, location: inject.location))
            }
        }
        
        if errors.isEmpty { return }
        
        throw ErrorCluster(errors: errors)
    }
    
    func getGraph() throws -> DependencyGraph {
        
//        for object in graphObjects {
//            object.objectType
//        }
        
        return DependencyGraph()
    }
}

private extension Array where Element == RegisterObject {
    func contains(objectType: ObjectType) -> Bool {
        return self.contains(where: { $0.additionalType.contains(objectType) || $0.objectType == objectType })
    }
}
