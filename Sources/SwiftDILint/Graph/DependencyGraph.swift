//
//  DependencyGraph.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation

class DependencyGraph: CustomStringConvertible {
    
    private var graph: [GraphVertex: [GraphNode]] = [:]
    
    func validate() throws {
        
    }
    
    func containsVertex(for object: RegisterObject) -> Bool {
        let vertex = GraphVertex(object: object)
        
        return graph[vertex] != nil
    }
    
    func createVertex(for object: RegisterObject) -> GraphVertex {
        let vertex = GraphVertex(object: object)
        
        if graph[vertex] == nil {
            graph[vertex] = []
        }
        
        return vertex
    }
    
    subscript(_ object: RegisterObject) -> [GraphNode]? {
        let vertex = GraphVertex(object: object)
        return graph[vertex]
    }
    
    func addNode(from source: GraphVertex, to destination: GraphVertex) {
        let node = GraphNode(from: source, to: destination)
        
        if graph[source] == nil {
            fatalError("Can't use node, because source vertex doesn't stored in current DependencyGraph")
        }
        
        graph[source]?.append(node)
    }
    
    func getNodes(from source: GraphVertex) -> [GraphNode]? {
        return graph[source]
    }
    
    var description: String {
      var result = ""
      for (vertex, edges) in graph {
        var edgeString = ""
        for (index, edge) in edges.enumerated() {
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
    var object: RegisterObject
    
    var description: String {
        return object.objectType.typeName
    }
    
}

struct GraphNode: Codable, Equatable, Hashable {
    let source: GraphVertex
    let destination: GraphVertex
    
    init(from source: GraphVertex, to destination: GraphVertex) {
        self.source = source
        self.destination = destination
    }
}
