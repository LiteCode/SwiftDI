//
//  HomeAssembly.swift
//  SwiftDIDemo
//
//  Created by v.a.prusakov on 27/06/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import SwiftDI

typealias Injected = Inject

struct HomeAssembly : DIPart {
    
    @Injected private var inject: HomeViewModel
    @CustomInject private var string: String
    
    var body: some DIPart {
        DIGroup {
            
            ServicesAssembly()
            
            services
            
            DIRegister(HomeViewModel.init)
                .as (HomeViewModel.self)
            
            DIGroup {
                services
            }
        }
    }
    
    private var services: some DIPart {
        ServicesAssembly()
    }
}

@propertyWrapper
struct CustomInject {
    
    var wrappedValue: String {
        return "kek"
    }
}
