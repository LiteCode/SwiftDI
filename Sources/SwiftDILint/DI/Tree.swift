//
//  Tree.swift
//  SwiftDI
//
//  Created by Vladislav Prusakov on 28.12.2019.
//

import Foundation

@available(OSX 10.15, *)
class Tree<T: Codable & Hashable & Identifiable>: Codable, Hashable {
    private(set) var value: T
    private(set) var nodes: [Tree<T>] = []
    
    init(value: T) {
        self.value = value
    }
    
    func append(_ node: Tree<T>) {
        nodes.append(node)
    }
    
    func search(_ value: T) -> Tree<T>? {
      if value == self.value {
        return self
      }
      for node in nodes {
        if let found = node.search(value) {
          return found
        }
      }
      return nil
    }
}

@available(OSX 10.15, *)
extension Tree: CustomStringConvertible {
    var description: String {
        
        var depth = 0
        return descriptionForNode(depth: &depth)
    }
    
    func descriptionForNode(depth: inout Int) -> String {
        var message = "\(String(describing: self.value))"
        
        if nodes.isEmpty { return message }
        
        depth += 1
        defer { depth -= 1}
        
        let spacings = String(repeating: " ", count: depth)
        let terminator = "\n\(spacings)-> "
        message += terminator + nodes.map { $0.descriptionForNode(depth: &depth) }.joined(separator: terminator)
        return message
    }
}

@available(OSX 10.15, *)
extension Tree {
    static func == (lhs: Tree<T>, rhs: Tree<T>) -> Bool {
        lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(nodes)
    }
}
