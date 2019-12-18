//
//  DIObject+DIPartBuildable.swift
//  SwiftDI
//
//  Created by Vladislav Prusakov on 16.12.2019.
//

import Foundation

extension DIObject: DIPartBuildable {
    func build(container: DIContainer) {
        container.registerObject(self)
    }
}
