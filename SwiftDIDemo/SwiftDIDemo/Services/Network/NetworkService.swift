//
//  NetworkService.swift
//  SwiftDIDemo
//
//  Created by v.a.prusakov on 27/06/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import SwiftUI
import SwiftDI
import Combine

protocol SessionServiceInput {
    func keka()
}

class SessionService : SessionServiceInput {
    @Injectable var networkService: NetworkService
    
    func keka() {
        print("keka")
        networkService.lol()
    }
}

class NetworkService : NetworkServiceInput {
    
    @Injectable var sessionService: SessionService
    
    func getData(block: @escaping (Data?) -> Void) {
        let url = URL(string: "https://avatars3.githubusercontent.com/u/45299494?s=200&v=4")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    block(data)
                }
            }
        }
        task.resume()
        sessionService.keka()
    }
    
    func lol() {
        print("lol")
    }
    
}
