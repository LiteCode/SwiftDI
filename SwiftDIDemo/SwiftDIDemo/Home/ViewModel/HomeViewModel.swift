//
//  HomeViewModel.swift
//  SwiftDIDemo
//
//  Created by v.a.prusakov on 28/06/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import UIKit.UIImage   // For UIImage
import SwiftDI         // You know it
import SwiftUI         // For BindableObject
import Combine         // For PassthroughSubject

class HomeViewModel : ObservableObject {
    
    @Inject var networkService: NetworkServiceInput
    
    @Published private(set) var image: UIImage?
    
    var hasData: Bool {
        return self.image != nil
    }
    
    func getData() {
        networkService.getData { [unowned self] data in
            guard let data = data else { return }
            DispatchQueue.global(qos: .background).async {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
    
    func clearData() {
        self.image = nil
    }
    
}
