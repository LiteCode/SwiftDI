//
//  DIGroup.swift
//  Pods-SwiftDIDemo
//
//  Created by Vladislav Prusakov on 16.12.2019.
//

import Foundation

public struct DIGroup<Part: DIPart>: DIPart {
    
    public var body: some DIPart {
        objects
    }
    
    let objects: Part
    
    public init(@DIBuilder objects: () -> Part) {
        self.objects = objects()
    }
    
    public func lifeCycle(_ value: DILifeCycle) -> some DIPart {
        _ = objects.lifeCycle(value)
        return self
    }
}

extension DIGroup {
    func build(container: DIContainer) {
        objects.build(container: container)
    }
}
