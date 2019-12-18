//
//  DIPart+DIPartBuildable.swift
//  SwiftDI
//
//  Created by Vladislav Prusakov on 16.12.2019.
//

import Foundation

extension DIPart {
    func build(container: DIContainer) {
        if let buildable = self as? DIPartBuildable {
            buildable.build(container: container)
        } else {
            self.body.build(container: container)
        }
    }
}
