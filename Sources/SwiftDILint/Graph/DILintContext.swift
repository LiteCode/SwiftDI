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
    
    private let isForceError: Bool
    
    init(isForceError: Bool) {
        self.isForceError = isForceError
    }
    
    private var allObjects: [RegisterObject] {
        return singletones + prototypies + graphObjects
    }
    
    func validate() throws {
        var errors: [XcodeError] = []
        for inject in injected {
            let type = inject.injectedType
            if !self.allObjects.contains(objectType: type) {
                    errors.append(DIError.missRegistration(type: inject.injectedType, location: inject.location))
            }
        }
        
        if errors.isEmpty { return }
        
        throw ErrorCluster(errors: errors, logLevel: isForceError ? .error : nil)
    }
    
    func getGraph() throws -> DependencyGraph {
        
        let graph = DependencyGraph()
        
        func graphResolver(for object: RegisterObject, depth: inout Int) throws {
            
            defer { depth -= 1 }
            
            let sourceVertex = graph.createVertex(for: object)
            
            let injectedProperties = self.findInjected(for: object)
            
            depth += 1
            
            for property in injectedProperties {
                guard let registredObject = findObject(by: property.injectedType) else {
                    throw DIError.missRegistration(type: property.injectedType, location: property.location)
                }
                
                if registredObject.lifeTime != .single && registredObject.lifeTime != .weakSingle {
                    
                    depth += 1
                    let destinationVertex = graph.createVertex(for: registredObject)
                    graph.addNode(from: sourceVertex, to: destinationVertex)
                    
                    try graphResolver(for: registredObject, depth: &depth)
                }
            }
        }
        
        for object in graphObjects {
            var graphDepth = 0
            try graphResolver(for: object, depth: &graphDepth)
        }
        
        return graph
    }
    
    private func findObject(by type: ObjectType) -> RegisterObject? {
        return allObjects.first(where: { $0.objectType == type || $0.additionalType.contains(type) })
    }
    
    private func findInjected(for registeredObject: RegisterObject) -> [InjectedProperty] {
        return self.injected.filter { registeredObject.objectType == $0.placeInObject || registeredObject.additionalType.contains($0.placeInObject) }
    }
    
}

private extension Array where Element == RegisterObject {
    func contains(objectType: ObjectType) -> Bool {
        return self.contains(where: { $0.additionalType.contains(objectType) || $0.objectType == objectType })
    }
}
