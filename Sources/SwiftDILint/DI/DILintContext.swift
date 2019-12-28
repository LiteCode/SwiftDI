//
//  DILintContext.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation

@available(OSX 10.15, *)
typealias DependencyGraph = Graph<RegisterObject>

@available(OSX 10.15, *)
typealias PartInitialTree = Tree<DIPart>

class DILintContext {
    var singletones: [RegisterObject] = []
    var graphObjects: [RegisterObject] = []
    var prototypies: [RegisterObject] = []
    var injected: [InjectedProperty] = []
    var parts: [DIPart] = []
    
    private let isForceError: Bool
    
    /// - Parameter isForceError: Replace all warnings to errors.
    init(isForceError: Bool) {
        self.isForceError = isForceError
    }
    
    private var allObjects: [RegisterObject] {
        return singletones + prototypies + graphObjects
    }
    
    /// We validate all found injected properties.
    /// If injected property doesn't have a registred object, that method throw error
    /// Otherwise, if we've unused registred object, method throw erros
    ///
    /// - Throws: Throw ErrorCluster object, contains all errors founded when validate performed.
    func validate() throws {
        var errors: [XcodeError] = []
        var usedRegistedObject: [RegisterObject] = []
        
        for inject in injected {
            let type = inject.injectedType
            if let object = self.findObject(by: type) {
                usedRegistedObject.append(object)
            } else {
                errors.append(DIError.missRegistration(type: inject.injectedType, location: inject.location))
            }
        }
        
        // Transform all unused registred object to errors
        errors += self.allObjects.lazy.filter { !usedRegistedObject.contains($0) }.map { DIError.unusedRegistration(type: $0.objectType, location: $0.location) }
        
        if errors.isEmpty { return }
        
        throw ErrorCluster(errors: errors, logLevel: isForceError ? .error : nil)
    }
    
    /// Build and return dependency graph for all registred object
    /// - Returns: Completed and validated dependency graph.
    @available(OSX 10.15, *)
    func dependencyGraph() throws -> DependencyGraph {
        
        let graph = DependencyGraph()
        
        @discardableResult
        func graphResolver(for object: RegisterObject, depth: inout Int) throws -> GraphVertex<RegisterObject> {
            defer { depth -= 1 }
            
            if graph.containsVertex(for: object) {
                return graph.createVertex(for: object)
            }
            
            let sourceVertex = graph.createVertex(for: object)
            
            let injectedProperties = self.findInjected(for: object)
            
            for property in injectedProperties {
                guard let registredObject = findObject(by: property.injectedType) else {
                    throw DIError.missRegistration(type: property.injectedType, location: property.location)
                }
                
                depth += 1
                let destinationVertex = try graphResolver(for: registredObject, depth: &depth)
                graph.addNode(from: sourceVertex, to: destinationVertex)
            }
            
            return sourceVertex
        }
        
        for object in allObjects {
            var graphDepth = 0
            try graphResolver(for: object, depth: &graphDepth)
        }
        
        return graph
    }
    
    // TODO: Support properties call in DIPart. Right now supported only struct/class calls
    @available(OSX 10.15, *)
    func partsInitialTree() throws -> PartInitialTree {
        
        var foundParts = parts
        guard let containerIndex = foundParts.firstIndex(where: { $0.kind == .container }) else {
            throw DIError.containerNotFound
        }
        
        let container = foundParts[containerIndex]
        foundParts.remove(at: containerIndex)
        
        let tree = Tree(value: container)
        
        @discardableResult
        func treeResolver(for part: DIPart) throws -> Tree<DIPart> {
            
            if let found = tree.search(part) {
                return found
            }
            
            let node = Tree(value: part)
            
            let parts = self.parts.filter { $0.parent == part.id }
            
            for part in parts {
                let leaf = try treeResolver(for: part)
                node.append(leaf)
            }
            
            return node
        }
            
        for part in foundParts.filter({ $0.parent == container.id }) {
            let node = try treeResolver(for: part)
            tree.append(node)
        }
        
        return tree
    }
    
    // MARK: - Private
    
    /// Return registred object by type
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
