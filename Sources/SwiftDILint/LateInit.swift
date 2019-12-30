//
//  LateInit.swift
//  
//
//  Created by Vladislav Prusakov on 30.12.2019.
//

import Foundation

@propertyWrapper
struct LateInit<T> {
    
    private var value: T?
    
    var wrappedValue: T {
        get {
            guard let value = value else {
                fatalError("Late init value '\(T.self)' is not being initialized.")
            }
            
            return value
        }
        
        set {
            self.value = newValue
        }
    }
}
