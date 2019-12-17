//
//  DIPart.swift
//  SwiftDI
//
//  Created by v.a.prusakov on 01/07/2019.
//

import Foundation

public protocol DIPart: AnyDIPart {
    @available(*, deprecated, message: "Use `var body: some DIPart` instead")
    static func load(container: DIContainer)
    
    associatedtype Body: DIPart
    var body: Self.Body { get }
}

public extension DIPart {
    static func load(container: DIContainer) { }
}
