//
//  NetworkService.swift
//  SwiftDIDemo
//
//  Created by v.a.prusakov on 27/06/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import SwiftUI
import Combine

class NetworkService: BindableObject {
    
    var didChange = PassthroughSubject<Void, Never>()
    
    var hasData = false
    
    func getData() {
        let url = URL(string: "https://github.com")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if data != nil {
                DispatchQueue.main.async {
                    self.hasData = true
                    self.didChange.send(())
                }
            }
            
            if error != nil {
                self.hasData = false
            }
        }
        task.resume()
    }
    
    func clearData() {
        DispatchQueue.main.async {
            self.hasData = false
            self.didChange.send(())
        }
        
    }
    
}
