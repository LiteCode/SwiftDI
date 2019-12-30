//
//  DILintResult.swift
//  
//
//  Created by Vladislav Prusakov on 30.12.2019.
//

import Foundation

@available(OSX 10.15, *)
struct DILintResult: Codable {
    let version: String
    let dependencies: DependencyGraph
    let parts: PartInitialTree
    
    func save(to path: URL) throws {
        let data = try JSONEncoder().encode(self)
        try data.write(to: path)
    }
}
