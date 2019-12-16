//
//  EmptyDI.swift
//  SwiftDI
//
//  Created by Vladislav Prusakov on 16.12.2019.
//

import Foundation

public struct EmptyDI: DIPart {
    public typealias Body = Never
    
    public var body: Never { fatalError() }
}

extension EmptyDI: DIPartBuildable {
    func build(container: DIContainer) { }
}
