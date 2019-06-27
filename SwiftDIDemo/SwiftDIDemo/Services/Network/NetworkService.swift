//
//  NetworkService.swift
//  SwiftDIDemo
//
//  Created by v.a.prusakov on 27/06/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import Combine
import Foundation

class NetworkService: NetworkServiceInput {
    
    func getData() {
        let publisher = URLSession.shared.dataTaskPublisher(for: URL(string: "")!)
        
    }
    
}
