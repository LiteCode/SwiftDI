//
//  DIPart.swift
//  SwiftDI
//
//  Created by v.a.prusakov on 01/07/2019.
//

import Foundation

public protocol DIPart {
    static func load(container: DIContainer)
}
