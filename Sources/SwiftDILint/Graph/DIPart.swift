//
//  File.swift
//  
//
//  Created by Vladislav Prusakov on 19.12.2019.
//

import Foundation

enum DIPart {
    indirect case group([DIPart])
    case register(RegisterObject)
    indirect case custom(DIPart)
}
