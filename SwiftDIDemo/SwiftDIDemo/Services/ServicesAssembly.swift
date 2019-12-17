//
//  ServicesAssembly.swift
//  SwiftDIDemo
//
//  Created by v.a.prusakov on 27/06/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import SwiftDI

struct ServicesAssembly: DIPart {
    
    var body: some DIPart {
        DIRegister(NetworkService.init)
            .as(NetworkServiceInput.self)
    }
}
