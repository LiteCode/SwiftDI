//
//  DIContainerConvertible.swift
//  
//
//  Created by v.a.prusakov on 27/06/2019.
//

import Foundation

/// If you wanna implement your custom DI Container, just use this protocol to conform SwiftDI.
public protocol DIContainerConvertible {
    func resolve<T>(bundle: Bundle?) -> T
    func didConnectToSwiftDI()
}

public extension DIContainerConvertible {
    func resolve<T>() -> T {
        return self.resolve(bundle: nil)
    }
}
