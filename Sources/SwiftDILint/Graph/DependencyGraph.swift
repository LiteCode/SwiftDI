//
//  DependencyGraph.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation
import PathKit

class DependencyGraph: Codable {
    
    var graph: [String: [String]] = [:]
    var nodes: [String: GraphNode] = [:]
    var vertexes: [String: GraphVertex] = [:]
    
    func validate() throws {
        
    }
    
    func containsVertex(for object: RegisterObject) -> Bool {
        let vertex = GraphVertex(object: object)
        
        return graph[vertex.id] != nil
    }
    
    func createVertex(for object: RegisterObject) -> GraphVertex {
        let vertex = GraphVertex(object: object)
        
        if graph[vertex.id] == nil {
            graph[vertex.id] = []
            vertexes[vertex.id] = vertex
        }
        
        return vertex
    }
    
    subscript(_ object: RegisterObject) -> [GraphNode]? {
        let vertex = GraphVertex(object: object)
        return graph[vertex.id]?.compactMap { nodes[$0] }
    }
    
    subscript(_ vertex: GraphVertex) -> [GraphNode]? {
        return graph[vertex.id]?.compactMap { nodes[$0] }
    }
    
    func addNode(from source: GraphVertex, to destination: GraphVertex) {
        let node = GraphNode(id: UUID().uuidString, from: source, to: destination)
        
        if graph[source.id] == nil {
            fatalError("Can't use node, because source vertex doesn't stored in current DependencyGraph")
        }
        
        nodes[node.id] = node
        graph[source.id]?.append(node.id)
    }
    
    func save(by path: Path) throws {
        let data = try JSONEncoder().encode(self)
        try path.write(data)
    }
    
    static func read(from path: Path) throws -> DependencyGraph? {
        let data = try path.read()
        return try JSONDecoder().decode(DependencyGraph.self, from: data)
    }
    
}

extension DependencyGraph: CustomStringConvertible {
    // taken from https://www.raywenderlich.com/773-swift-algorithm-club-graphs-with-adjacency-list
    var description: String {
        var result = ""
        for (vertexId, edges) in graph {
            guard let vertex = vertexes[vertexId] else { continue }
            
            var edgeString = ""
            for (index, edgeId) in edges.enumerated() {
                guard let edge = nodes[edgeId] else { continue }
                
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ] \n ")
        }
        return result
    }
}

struct GraphVertex: Codable, Equatable, Hashable, CustomStringConvertible {
    let id: String
    let object: RegisterObject
    
    init(object: RegisterObject) {
        self.id = object.objectType.typeName
        self.object = object
    }
    
    var description: String {
        return object.objectType.typeName
    }
    
}

struct GraphNode: Codable, Equatable, Hashable {
    let id: String
    let source: GraphVertex
    let destination: GraphVertex
    
    init(id: String, from source: GraphVertex, to destination: GraphVertex) {
        self.id = id
        self.source = source
        self.destination = destination
    }
}
