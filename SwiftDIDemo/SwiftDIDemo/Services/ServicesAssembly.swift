//
//  ServicesAssembly.swift
//  SwiftDIDemo
//
//  Created by v.a.prusakov on 27/06/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import SwiftDI

class ServicesAssembly: DIPart {
    static func load(container: DIContainer) {
        container.register(NetworkService.init)
            .lifeCycle(.single)
            .as (NetworkServiceInput.self)
        
        container.register(SessionService.init)
            .as(SessionServiceInput.self)
    }
}
