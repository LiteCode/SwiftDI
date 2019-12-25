//
//  File.swift
//  
//
//  Created by Vladislav Prusakov on 25.12.2019.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
