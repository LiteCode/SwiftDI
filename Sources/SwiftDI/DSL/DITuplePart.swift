//
//  DITuplePart.swift
//  SwiftDI
//
//  Created by Vladislav Prusakov on 16.12.2019.
//

import Foundation

public struct DITuplePart<T>: DIPart {
    public typealias Body = Never
    
    public var body: Never { fatalError() }
    
    let objects: T
    
    init(_ objects: T) {
        self.objects = objects
    }
}

extension DITuplePart: DIPartBuildable {
    func build(container: DIContainer) {
        for child in Mirror(reflecting: objects).children {
            if let buildable = child.value as? DIPartBuildable {
                buildable.build(container: container)
            } else if let part = child.value as? AnyDIPart {
                part.build(container: container)
            }
        }
    }
}

fileprivate extension AnyDIPart {
    func build(container: DIContainer) {
        if let buildable = self._body as? DIPartBuildable {
            buildable.build(container: container)
        } else if let body = self._body as? AnyDIPart {
            body.build(container: container)
        }
    }
}
