//
//  Graph.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation
import PathKit

@available(OSX 10.15, *)
class Graph<T: Codable & Hashable & Identifiable>: Codable where T.ID: Codable {
    
    var graph: [T.ID: [String]] = [:]
    var nodes: [String: GraphNode<T>] = [:]
    var vertexes: [T.ID: GraphVertex<T>] = [:]
    
    func containsVertex(for object: T) -> Bool {
        let vertex = GraphVertex(object: object)
        
        return graph[vertex.id] != nil
    }
    
    subscript(_ object: T) -> [GraphNode<T>]? {
        let vertex = GraphVertex(object: object)
        return graph[vertex.id]?.compactMap { nodes[$0] }
    }
    
    func createVertex(for object: T) -> GraphVertex<T> {
        let vertex = GraphVertex(object: object)
        
        if graph[vertex.id] == nil {
            graph[vertex.id] = []
            vertexes[vertex.id] = vertex
        }
        
        return vertex
    }
    
    subscript(_ vertex: GraphVertex<T>) -> [GraphNode<T>]? {
        return graph[vertex.id]?.compactMap { nodes[$0] }
    }
    
    func addNode(from source: GraphVertex<T>, to destination: GraphVertex<T>) {
        let node = GraphNode(id: UUID().uuidString, from: source, to: destination)
        
        if graph[source.id] == nil {
            fatalError("Can't use node, because source vertex doesn't stored in current Graph")
        }
        
        nodes[node.id] = node
        graph[source.id]?.append(node.id)
    }
    
    func save(by path: Path) throws {
        let data = try JSONEncoder().encode(self)
        try path.write(data)
    }
    
    static func read<T: Codable & Hashable>(from path: Path) throws -> Graph<T>? {
        let data = try path.read()
        return try JSONDecoder().decode(Graph<T>.self, from: data)
    }
    
}

@available(OSX 10.15, *)
extension Graph: CustomStringConvertible {
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

@available(OSX 10.15, *)
extension GraphVertex where T == RegisterObject {
    var description: String {
        return object.objectType.typeName
    }
}

@available(OSX 10.15, *)
struct GraphVertex<T: Codable & Hashable & Identifiable>: Codable, Equatable, Hashable, CustomStringConvertible where T.ID: Codable {
    
    let id: T.ID
    let object: T
    
    init(object: T) {
        self.id = object.id
        self.object = object
    }
    
    var description: String {
        return String(describing: object)
    }
}

@available(OSX 10.15, *)
struct GraphNode<T: Codable & Hashable & Identifiable>: Codable, Equatable, Hashable where T.ID: Codable {
    let id: String
    let source: GraphVertex<T>
    let destination: GraphVertex<T>
    
    init(id: String, from source: GraphVertex<T>, to destination: GraphVertex<T>) {
        self.id = id
        self.source = source
        self.destination = destination
    }
}
