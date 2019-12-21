//
//  DIContext.swift
//  
//
//  Created by Vladislav Prusakov on 18.12.2019.
//

import Foundation


class DIContext {
    var registers: [RegisterObject] = []
    var injections: [InjectedProps] = []
    var parts: [DIPart] = []
    
    func getGraph() throws -> DependencyGraph {
        return DependencyGraph()
    }
}
