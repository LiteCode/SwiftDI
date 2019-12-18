//
//  DIPartBuildable.swift
//  SwiftDI
//
//  Created by Vladislav Prusakov on 16.12.2019.
//

import Foundation

protocol DIPartBuildable {
    func build(container: DIContainer)
}
