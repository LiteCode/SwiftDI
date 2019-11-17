//
//  HomeAssembly.swift
//  SwiftDIDemo
//
//  Created by v.a.prusakov on 27/06/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import SwiftDI

class HomeAssembly : DIPart {
    static func load(container: DIContainer) {
        container.register(HomeViewModel.init)
            .lifeCycle(.prototype)
    }
}
