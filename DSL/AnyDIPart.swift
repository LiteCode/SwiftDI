//
//  AnyDIPart.swift
//  SwiftDI
//
//  Created by Vladislav Prusakov on 16.12.2019.
//

import Foundation

public protocol AnyDIPart {
    var _body: Any { get }
}

extension AnyDIPart where Self: DIPart {
    public var _body: Any {
        self.body
    }
}
